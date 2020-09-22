import 'dart:async';
import 'dart:io';

import 'dart:ui' as ui;

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_app_links/flutter_facebook_app_links.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valley/game/data/constants.dart';
import 'package:valley/game/domain/providers/button_provider.dart';
import 'package:valley/game/domain/utilities/connection_status_singleton.dart';
import 'package:valley/game/presentation/pages/home_page.dart';
import 'package:valley/game/presentation/pages/no_connection_page.dart';
import 'package:valley/game/presentation/pages/start_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();

  final String afDevKey = 'W59mYRZg6zQvQi7Jth7PfF';

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String deepLink = 'nothingFromFacebook';

  Map appsFlyerOptions = {
    "afDevKey": afDevKey,
    "afAppId": "_",
    "isDebug": false
  };

  AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);

  await appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true);

  final Map<String, String> facebookDeepLink =
      await FlutterFacebookAppLinks.initFBLinks();

  if (facebookDeepLink != null) {
    deepLink = facebookDeepLink['deeplink'].split('?').last;
    await prefs.setString('deeplink', deepLink);
  } else {
    try {
      deepLink = prefs.getString('deeplink');
      deepLink ??= 'nothingFromSharedPref';
    } catch (e) {
      print('error reading from shared_pref $e');
      deepLink = e.toString();
    }
  }

  final String appsFlyerUid = await appsflyerSdk.getAppsFlyerUID();

  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
    }
  } on SocketException catch (_) {
    print('not connected');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ButtonProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyApp(appsflyerSdk, deepLink, appsFlyerUid),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final AppsflyerSdk appsflyerSdk;
  final String facebookDeepLink;
  final String appsFlyerUid;
  MyApp(this.appsflyerSdk, this.facebookDeepLink, this.appsFlyerUid);

  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamController<String> _controller;
  StreamSubscription _connectionChangeStream;

  bool isOffline = false;

  @override
  initState() {
    super.initState();

    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }

  Stream<String> initPlatformState() {
    _controller = StreamController<String>();

    Stream stream = _controller.stream;
    String targetUrl = '?nothing';
    String deepLink = widget.facebookDeepLink;
    String deepLinkAppsFlyer = 'sub_id_10=${widget.appsFlyerUid}';

    targetUrl =
        UrlConstants.URL_PATH + '?' + deepLink + '&' + deepLinkAppsFlyer;

    _controller.add(targetUrl);
    return stream;
  }

  @override
  void dispose() {
    if (_controller != null) {
      _controller.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _sysLng = ui.window.locale.languageCode;
    print(_sysLng);
    return _sysLng == 'ru' ||
            _sysLng == 'ua' ||
            _sysLng == 'kz' ||
            _sysLng == 'az' ||
            _sysLng == 'mo' || // Moldavian
            _sysLng == 'de'
        ? buildStreamBuilder()
        : StartPage();
  }

  StreamBuilder<String> buildStreamBuilder() {
    return StreamBuilder(
        stream: initPlatformState(),
        builder: (context, snapshot) {
          if (snapshot != null && snapshot.hasData) {
            if (!isOffline) {
              print('TARGET URL ============> ${snapshot.data}');
              final String targetUrl = snapshot.data;
              return HomePage(url: targetUrl);
            } else {
              return NoConnectionPage();
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

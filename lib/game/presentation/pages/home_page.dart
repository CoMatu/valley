import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();

class HomePage extends StatefulWidget {
  final String url;
  const HomePage({@required this.url, Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: WebviewScaffold(
          url: widget.url,
          javascriptChannels: jsChannels,
          mediaPlaybackRequiresUserGesture: false,
          withZoom: true,
          withLocalStorage: true,
          resizeToAvoidBottomInset: true,
          hidden: true,
          initialChild: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xff033682), Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            child: const Center(
              child: Text(
                'Waiting.....',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

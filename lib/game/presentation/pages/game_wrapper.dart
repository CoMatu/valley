import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:valley/game/data/slot_model.dart';
import 'package:valley/game/domain/game_logic/game_logic.dart';
import 'package:valley/game/presentation/pages/start_page.dart';
import 'package:valley/game/presentation/widget/slot_widget.dart';

import '../../domain/providers/button_provider.dart';

class GameWrapper extends StatefulWidget {
  @override
  GameWrapperState createState() => GameWrapperState();
}

class GameWrapperState extends State<GameWrapper> {
  ButtonProvider buttonProvider;
  GameLogic _gameLogic;

  final GlobalKey<SlotWidgetState> _key1 = GlobalKey();
  final GlobalKey<SlotWidgetState> _key2 = GlobalKey();
  final GlobalKey<SlotWidgetState> _key3 = GlobalKey();
  final GlobalKey<SlotWidgetState> _key4 = GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List keys;

  @override
  void initState() {
    super.initState();
    keys = <GlobalKey<SlotWidgetState>>[
      _key1,
      _key2,
      _key3,
      _key4,
    ];
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    buttonProvider = Provider.of<ButtonProvider>(context, listen: false);
    _gameLogic = GameLogic(keys: keys);
    _gameLogic.slotGenerator();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: scaffoldKey,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              buildScorePanel(context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  buildSlot(context, 'assets/images/Hero-1.png', _key1),
                  buildSlot(context, 'assets/images/Hero-2.png', _key2),
                  buildSlot(context, 'assets/images/Hero-3.png', _key3),
                  buildSlot(context, 'assets/images/Hero-4.png', _key4),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSlot(
      BuildContext context, String imagePath, GlobalKey<SlotWidgetState> key) {
    return Stack(
      children: <Widget>[
        SlotWidget(
          key: key,
          slot: SlotModel(
            duration: Duration(seconds: 2),
            isVisible: true,
            delay: 1,
            end: MediaQuery.of(context).size.height * 0.7,
          ),
        ),
        buildGamePad(imagePath, context, key),
        Positioned.fill(
            //         top: MediaQuery.of(context).size.height * 0.19,
//            left: MediaQuery.of(context).size.width * 0.057,
            top: MediaQuery.of(context).size.height * 0.1,
            child: Align(
                alignment: Alignment.center,
                child: buildLazer(context, imagePath))),
      ],
    );
  }

  Column buildGamePad(
      String imagePath, BuildContext context, GlobalKey<SlotWidgetState> key) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        buildHero(imagePath),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
        ),
        //buildLazer(context, imagePath),
        buildLazerBase(imagePath, key),
      ],
    );
  }

  Widget buildHero(String imagePath) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: 70,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/shadow-under-gods.png'),
                fit: BoxFit.fill),
          ),
        ),
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage(imagePath), fit: BoxFit.fill),
          ),
        )
      ],
    );
  }

  Widget buildLazerBase(String providerKey, GlobalKey<SlotWidgetState> key) {
    return Consumer<ButtonProvider>(
      builder: (context, value, child) {
        return GestureDetector(
          onTapDown: (details) => buttonProvider.imageForTapDown(providerKey),
          onTapUp: (details) => buttonProvider.imageForTapUp(providerKey),
          onTap: () => key.currentState.updateSlot(),
          child: Container(
            height: 40,
            width: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(value.image(providerKey)),
                  fit: BoxFit.fill),
            ),
          ),
        );
      },
    );
  }

  Widget buildLazer(BuildContext context, String key) {
    return Consumer<ButtonProvider>(
      builder: (context, value, child) => Container(
        height: MediaQuery.of(context).size.height * 0.53,
        width: 20,
        decoration: value.image(key) != 'assets/images/lazer-base.png'
            ? BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/lazer.png'),
                    fit: BoxFit.fill),
              )
            : null,
      ),
    );
  }

  Widget buildScorePanel(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.25,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/score-bar.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
          child: Consumer<ButtonProvider>(
        builder: (context, value, child) => Text(
          'SCORE ${value.scope.toString().padLeft(5, '0')}',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      )),
    );
  }

  showAlertDialog(BuildContext context, int scope, bestScore) {
    var textStyle = TextStyle(
        fontWeight: FontWeight.bold, color: Colors.yellow[100], fontSize: 20);
    var textStyleScope = TextStyle(
        fontWeight: FontWeight.bold, color: Colors.white, fontSize: 30);
    AlertDialog alert = AlertDialog(
        backgroundColor: Colors.transparent,
        content: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          width: MediaQuery.of(context).size.width * 0.5,
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/best_score.png'),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Your result', style: textStyle),
                    Text(scope.toString().padLeft(5, '0'),
                        style: textStyleScope),
                    Text('Best result', style: textStyle),
                    Text(bestScore.toString().padLeft(5, '0'),
                        style: textStyleScope),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  ],
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () {
                      Provider.of<ButtonProvider>(context, listen: false)
                          .clearScope();
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => StartPage()));
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/restart.png'),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

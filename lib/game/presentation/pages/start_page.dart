import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:valley/game/domain/providers/button_provider.dart';
import 'package:valley/game/presentation/pages/game_wrapper.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: FlatButton(
                    onPressed: () async {
                      await Provider.of<ButtonProvider>(context, listen: false)
                          .getBestResult();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameWrapper(),
                          ));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.22,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/play_button.png'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

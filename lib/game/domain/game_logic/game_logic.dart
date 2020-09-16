import 'package:flutter/material.dart';
import 'package:valley/game/presentation/widget/slot_widget.dart';

class GameLogic {
  final List<GlobalKey<SlotWidgetState>> keys;
  GameLogic({@required this.keys});

  void slotGenerator() async {
    var duration;
    for (int i = 0; i < 5500; i++) {
      if (i < 3) {
        duration = 2000;
      } else if (i >= 3 && i < 6) {
        duration = 1500;
      } else {
        duration = 800;
      }
      for (GlobalKey<SlotWidgetState> key in keys) {
        await Future.delayed(Duration(milliseconds: duration));
        if (key.currentState != null) {
          key.currentState.startGame();
        }
      }
    }
  }
}

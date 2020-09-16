import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valley/game/data/constants.dart';
import 'package:valley/game/data/slot_model.dart';
import 'package:valley/game/domain/providers/button_provider.dart';
import 'package:valley/game/presentation/pages/game_wrapper.dart';

class SlotWidget extends StatefulWidget {
  SlotWidget({
    @required this.slot,
    Key key,
  }) : super(key: key);

  final SlotModel slot;

  @override
  SlotWidgetState createState() => SlotWidgetState();
}

class SlotWidgetState extends State<SlotWidget> with TickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;
  ButtonProvider _buttonProvider;
  String image;
  bool isVisible = true;
  SlotType slotType;
  int scope;

  @override
  void initState() {
    super.initState();

    slotType = getRandomSlot();
    image = getSlotImage(slotType);
    print('slot key=${widget.key.toString()} ++++++ $slotType');

    _buttonProvider = Provider.of(context, listen: false);
    animationController =
        AnimationController(vsync: this, duration: widget.slot.duration);
    animation = Tween<double>(begin: 0, end: widget.slot.end)
        .animate(animationController);
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void updateSlot() {
    if (slotType == SlotType.DEAD_1 || slotType == SlotType.DEAD_2) {
      stopGame();
      return;
    }
    print(slotType);
    setState(() {
      _buttonProvider.increment();
      animationController.reset();
    });
  }

  void startGame() {
    slotType = getRandomSlot();
    image = getSlotImage(slotType);
    print('PERIODIC slot key=${widget.key.toString()} ++++++ $slotType');

    setState(() {
      isVisible = true;
    });
    animationController.forward();
  }

  void stopGame() async {
    animationController.reset();
    scope = _buttonProvider.scope;
    final _best = _buttonProvider.bestScore;
    if (scope > _best) {
      await _buttonProvider.setBestResult(scope);
    }
    GameWrapperState().showAlertDialog(context, scope, _best);
  }

  @override
  Widget build(BuildContext context) {
    return isVisible
        ? Container(
            width: 100,
            child: AnimatedBuilder(
                animation: animation,
                builder: (BuildContext context, Widget child) {
                  return Transform.translate(
                    offset: Offset(0, animation.value),
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(image),
                        ),
                      ),
                    ),
                  );
                }),
          )
        : SizedBox(
            height: 1,
          );
  }

  String getSlotImage(SlotType slotType) {
    if (slotType == SlotType.TYPE_1) {
      return 'assets/images/Slot-1.png';
    } else if (slotType == SlotType.TYPE_2) {
      return 'assets/images/Slot-2.png';
    } else if (slotType == SlotType.TYPE_3) {
      return 'assets/images/Slot-3.png';
    } else if (slotType == SlotType.DEAD_1) {
      return 'assets/images/dead_1.png';
    } else if (slotType == SlotType.DEAD_2) {
      return 'assets/images/dead_2.png';
    }
    return 'assets/images/Slot-4.png';
  }

  SlotType getRandomSlot() {
    var slot = Random().nextInt(6);
    switch (slot) {
      case 0:
        return SlotType.TYPE_1;
      case 1:
        return SlotType.TYPE_2;
      case 2:
        return SlotType.TYPE_3;
      case 3:
        return SlotType.TYPE_4;
      case 4:
        return SlotType.DEAD_1;
      case 5:
        return SlotType.DEAD_2;
        break;
      default:
        return SlotType.TYPE_1;
    }
  }
}

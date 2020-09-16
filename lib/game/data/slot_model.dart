import 'package:flutter/material.dart';

class SlotModel {
  final Duration duration;
  final bool isVisible;
  final int delay;
  final double end;

  SlotModel({
    @required this.duration,
    @required this.isVisible,
    @required this.delay,
    @required this.end,
  });
}

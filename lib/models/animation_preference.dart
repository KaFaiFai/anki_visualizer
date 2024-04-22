import 'package:flutter/material.dart';

class AnimationPreference {
  int milliseconds;
  DateTimeRange dateRange;
  int numCol;

  AnimationPreference({
    required this.milliseconds,
    required this.dateRange,
    required this.numCol,
  });

  @override
  String toString() {
    return "Preference(seconds: $milliseconds, selectedRange: $dateRange, numCol: $numCol)";
  }
}

import 'package:flutter/material.dart';

class Preference {
  int seconds;
  DateTimeRange selectedRange;
  int numCol;

  Preference({
    required this.seconds,
    required this.selectedRange,
    required this.numCol,
  });

  @override
  String toString() {
    return "Preference(seconds: $seconds, selectedRange: $selectedRange, numCol: $numCol)";
  }
}

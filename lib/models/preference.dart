import 'package:flutter/material.dart';

class Preference {
  int seconds;
  DateTimeRange dateRange;
  int numCol;

  Preference({
    required this.seconds,
    required this.dateRange,
    required this.numCol,
  });

  @override
  String toString() {
    return "Preference(seconds: $seconds, selectedRange: $dateRange, numCol: $numCol)";
  }
}

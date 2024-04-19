import 'package:flutter/material.dart';

class Preference {
  int milliseconds;
  DateTimeRange dateRange;
  int numCol;

  Preference({
    required this.milliseconds,
    required this.dateRange,
    required this.numCol,
  });

  @override
  String toString() {
    return "Preference(seconds: $milliseconds, selectedRange: $dateRange, numCol: $numCol)";
  }
}

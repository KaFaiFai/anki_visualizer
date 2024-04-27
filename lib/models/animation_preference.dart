import 'package:anki_visualizer/models/date_range.dart';

class AnimationPreference {
  int milliseconds;
  DateRange dateRange;
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

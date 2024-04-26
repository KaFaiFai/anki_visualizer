import 'package:anki_visualizer/models/date.dart';
import 'package:flutter/material.dart';

/// A wrapper of DateTimeRange that only concerns about date
class DateRange {
  final Date start;
  final Date end;

  DateRange({
    required this.start,
    required this.end,
  }) : assert(start <= end);

  factory DateRange.fromDateTimeRange(DateTimeRange dateTimeRange) {
    return DateRange(start: Date.fromDateTime(dateTimeRange.start), end: Date.fromDateTime(dateTimeRange.end));
  }

  DateTimeRange toDateTimeRange() {
    return DateTimeRange(start: start.toDateTime(), end: end.toDateTime());
  }

  @override
  String toString() {
    return "$start - $end";
  }
}

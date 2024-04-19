import 'package:intl/intl.dart';

/// A wrapper of DateTime that only concerns about date
class Date implements Comparable<Date> {
  int year;
  int month;
  int day;

  Date(this.year, this.month, this.day);

  factory Date.fromDateTime(DateTime dateTime) {
    final year = dateTime.year;
    final month = dateTime.month;
    final day = dateTime.day;
    return Date(year, month, day);
  }

  factory Date.today() {
    return Date.fromDateTime(DateTime.now());
  }

  factory Date.fromTimestamp({required int milliseconds}) {
    return Date.fromDateTime(DateTime.fromMillisecondsSinceEpoch(milliseconds));
  }

  DateTime toDateTime() {
    return DateTime(year, month, day);
  }

  Date add(int numDays) {
    return Date.fromDateTime(toDateTime().add(Duration(days: numDays)));
  }

  int difference(Date other) {
    /// returns negative this occurs before other
    return toDateTime().difference(other.toDateTime()).inDays;
  }

  static Date fromString(String dateString) {
    final dateTime = DateTime.parse(dateString);
    return Date.fromDateTime(dateTime);
  }

  @override
  String toString() {
    return DateFormat('yyyy-MM-dd').format(toDateTime());
  }

  String toStringUS() {
    return DateFormat.yMMMMd('en_US').format(toDateTime());
  }

  @override
  bool operator ==(Object other) {
    return other is Date && year == other.year && month == other.month && day == other.day;
  }

  @override
  int get hashCode {
    return Object.hash(year, month, day);
  }

  @override
  int compareTo(Date other) {
    int diff = difference(other);
    if (diff < 0) {
      return -1;
    } else if (diff > 0) {
      return 1;
    } else {
      return 0;
    }
  }
}

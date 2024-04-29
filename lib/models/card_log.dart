import 'package:anki_visualizer/services/database/entities/review.dart';

import 'date.dart';

class CardLog {
  final String text;
  final Map<Date, List<Review>> reviewsByDate; // use dictionary to accelerate filtering reviews with date

  CardLog(this.text, this.reviewsByDate);

  factory CardLog.fromReviewsList(String text, List<Review> reviews) {
    final reviewsByDate = <Date, List<Review>>{};
    for (final r in reviews) {
      final date = Date.fromTimestamp(milliseconds: r.id);
      reviewsByDate.update(date, (value) => value..add(r), ifAbsent: () => [r]);
    }
    return CardLog(text, reviewsByDate);
  }
}

import 'package:anki_progress/services/database/review.dart';

class CardLog {
  final String text;
  final List<Review> reviews;

  CardLog(this.text, this.reviews);
}

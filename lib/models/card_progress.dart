import 'package:anki_progress/services/database/review.dart';

class CardProgress {
  final String text;
  final List<Review> reviews;

  CardProgress(this.text, this.reviews);
}

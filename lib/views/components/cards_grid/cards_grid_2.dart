import 'dart:math';

import 'package:flutter/material.dart' hide Card;

import '../../../core/values.dart';
import '../../../models/animation_preference.dart';
import '../../../models/card_log.dart';
import '../../../models/date.dart';
import '../../../models/date_range.dart';
import '../../../services/database/entities/review.dart';
import '../../run_with_app_container.dart';

void main() {
  final cardLogs = List.generate(
    500,
    (index) => CardLog.fromReviewsList(
      "card $index",
      List.generate(
        20,
        (_) => Review(id: index, cid: 0, ease: 0, ivl: 0, lastIvl: 0, time: 0, type: 0),
      ),
    ),
  );
  final preference = AnimationPreference(
    milliseconds: 3000,
    dateRange: DateRange(start: Date.today(), end: Date.today()),
    numCol: 10,
  );
  runWithAppContainer(CardsGrid2(cardLogs: cardLogs, preference: preference, fontSize: 12.0, maxWidth: 50.0));
}

/// Zoomed out view that displays all cards at once
class CardsGrid2 extends StatefulWidget {
  final List<CardLog> cardLogs;
  final AnimationPreference preference;
  final double fontSize;
  final double maxWidth;

  const CardsGrid2({super.key, required this.cardLogs, required this.preference, required this.fontSize, required this.maxWidth});

  @override
  State<CardsGrid2> createState() => CardsGrid2State();
}

class CardsGrid2State extends State<CardsGrid2> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;
  late final Duration animationDuration;
  late final Date start;
  late final Date end;

  @override
  void initState() {
    super.initState();
    animationDuration = Duration(milliseconds: widget.preference.milliseconds);
    animationController = AnimationController(duration: animationDuration, vsync: this)
      ..addListener(() {
        setState(() {});
      });
    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);

    start = widget.preference.dateRange.start;
    end = widget.preference.dateRange.end;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      resetState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          Text(currentDate.toString()),
          Expanded(
            child: Wrap(
              spacing: 2.0, // 卡片之间的水平间距
              runSpacing: 3.0, // 卡片之间的垂直间距
              alignment: WrapAlignment.spaceEvenly,
              children: widget.cardLogs.map((cardLog) {
                return ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: widget.maxWidth),
                  child: _CardProgress(cardLog: cardLog, date: currentDate, fontSize: widget.fontSize),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Date get currentDate {
    final diff = end.difference(start);
    return start.add((diff * animation.value).floor());
  }

  void resetState() {
    animationController.reset();
  }

  void playProgress() {
    animationController.forward();
  }
}

class _CardProgress extends StatelessWidget {
  final CardLog cardLog;
  final Date date;
  final double fontSize;

  const _CardProgress({required this.cardLog, required this.date, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    Review? lastReview; // latest review on or before the date
    if (cardLog.reviewsByDate.keys.contains(date)) {
      lastReview = cardLog.reviewsByDate[date]!.first;
    } else {
      for (final entry in cardLog.reviewsByDate.entries) {
        final reviewDate = entry.key;
        final reviews = entry.value;
        if (reviewDate <= date) lastReview = reviews.first;
        if (reviewDate >= date) break;
      }
    }

    final Color cardColor;
    final Color textColor;
    if (lastReview == null) {
      cardColor = Values.progressColor.withAlpha(0);
      textColor = Theme.of(context).colorScheme.onBackground;
    } else {
      final lastReviewDate = Date.fromTimestamp(milliseconds: lastReview.id);
      if (lastReviewDate < date) {
        final datePassed = date.difference(lastReviewDate);
        final value = datePassed * cardLog.reviewsByDate.length; // more reviews -> deeper color
        cardColor = Values.progressColor.withAlpha(min(value, 255));
        textColor = Theme.of(context).colorScheme.onBackground;
      } else {
        final easeColorMap = {1: Values.againColor, 2: Values.hardColor, 3: Values.goodColor, 4: Values.easyColor};
        cardColor = easeColorMap[lastReview.ease] ?? Colors.brown.withAlpha(50);
        textColor = Theme.of(context).colorScheme.background;
      }
    }

    return Container(
      color: cardColor,
      // alignment: Alignment,
      padding: const EdgeInsets.only(left: 3.0, right: 3.0),
      child: Tooltip(
        message: cardLog.text,
        child: Text(
          cardLog.text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: textColor, fontSize: fontSize),
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
          maxLines: 1,
        )),
    );
  }
}

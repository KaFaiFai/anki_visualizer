// import 'dart:math';
//
// import 'package:anki_visualizer/core/values.dart';
// import 'package:anki_visualizer/models/animation_preference.dart';
// import 'package:anki_visualizer/models/card_log.dart';
// import 'package:anki_visualizer/models/date_range.dart';
// import 'package:anki_visualizer/services/database/entities/review.dart';
// import 'package:anki_visualizer/views/run_with_app_container.dart';
// import 'package:flutter/material.dart' hide Card;
//
// import '../../../models/date.dart';
//
// void main() {
//   final cardLogs = List.generate(
//     500,
//     (index) => CardLog.fromReviewsList(
//       "card $index",
//       List.generate(
//         20,
//         (_) => Review(id: index, cid: 0, ease: 0, ivl: 0, lastIvl: 0, time: 0, type: 0),
//       ),
//     ),
//   );
//   final preference = AnimationPreference(
//     milliseconds: 3000,
//     dateRange: DateRange(start: Date.today(), end: Date.today()),
//     numCol: 10,
//   );
//   runWithAppContainer(CardsGrid1(cardLogs: cardLogs, preference: preference));
// }
//
// /// Scrolling view for a subset of cards
// class CardsGrid1 extends StatefulWidget {
//   final List<CardLog> cardLogs;
//   final AnimationPreference preference;
//
//   const CardsGrid1({super.key, required this.cardLogs, required this.preference});
//
//   @override
//   State<CardsGrid1> createState() => CardsGrid1State();
// }
//
// class CardsGrid1State extends State<CardsGrid1> with SingleTickerProviderStateMixin {
//   late final ScrollController scrollController;
//   late final AnimationController animationController;
//   late final Animation<double> animation;
//   late final Duration animationDuration;
//   late final Date start;
//   late final Date end;
//
//   @override
//   void initState() {
//     super.initState();
//     animationDuration = Duration(milliseconds: widget.preference.milliseconds);
//
//     scrollController = ScrollController();
//     animationController = AnimationController(duration: animationDuration, vsync: this)
//       ..addListener(() {
//         // sync scroll position with animation value
//         final position = scrollController.position.maxScrollExtent * animation.value;
//         scrollController.jumpTo(position);
//         setState(() {});
//       });
//     animation = Tween(begin: 0.0, end: 1.0).animate(animationController);
//
//     start = widget.preference.dateRange.start;
//     end = widget.preference.dateRange.end;
//
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       resetState();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Theme.of(context).colorScheme.background,
//       child: Column(
//         children: [
//           Text(currentDate.toString()),
//           Expanded(
//             child: GridView.builder(
//               controller: scrollController,
//               scrollDirection: Axis.vertical,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: widget.preference.numCol,
//                 mainAxisSpacing: 10,
//                 crossAxisSpacing: 10,
//                 childAspectRatio: 1.8,
//               ),
//               itemCount: widget.cardLogs.length,
//               itemBuilder: (BuildContext context, int index) =>
//                   CardProgress(cardLog: widget.cardLogs[index], date: currentDate),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     scrollController.dispose();
//     animationController.dispose();
//     super.dispose();
//   }
//
//   Date get currentDate {
//     final diff = end.difference(start);
//     return start.add((diff * animation.value).floor());
//   }
//
//   void resetState() {
//     animationController.reset();
//   }
//
//   void playProgress() {
//     /// start scrolling downward and move date forward
//     animationController.forward();
//   }
// }
//
// class CardProgress extends StatelessWidget {
//   final CardLog cardLog;
//   final Date date;
//
//   const CardProgress({super.key, required this.cardLog, required this.date});
//
//   @override
//   Widget build(BuildContext context) {
//     final Review? review =
//         cardLog.reviewsByDate.where((e) => Date.fromTimestamp(milliseconds: e.id) == date).firstOrNull;
//     final Color cardColor;
//     final Color textColor;
//     if (review == null) {
//       final prevReviews = cardLog.reviewsByDate.where((e) => Date.fromTimestamp(milliseconds: e.id) < date);
//       final prevReview = prevReviews.lastOrNull;
//       final datePassed = prevReview == null ? 0 : date.difference(Date.fromTimestamp(milliseconds: prevReview.id));
//       final value = datePassed;
//       cardColor = Colors.amber.withAlpha(min(value, 255));
//       textColor = Theme.of(context).colorScheme.onBackground;
//     } else {
//       final easeColorMap = {1: Values.againColor, 2: Values.hardColor, 3: Values.goodColor, 4: Values.easyColor};
//       cardColor = easeColorMap[review.ease] ?? Colors.brown.withAlpha(50);
//       textColor = Theme.of(context).colorScheme.background;
//     }
//
//     return Container(
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(5),
//         border: Border.all(color: Theme.of(context).colorScheme.outline, width: 2),
//       ),
//       alignment: Alignment.center,
//       child: Text(cardLog.text, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: textColor)),
//     );
//   }
// }

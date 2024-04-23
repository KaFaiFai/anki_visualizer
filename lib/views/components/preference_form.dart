import 'package:flutter/material.dart';

import '../../models/animation_preference.dart';
import '../../models/card_log.dart';
import '../../models/date.dart';
import '../basic/padded_column.dart';

class PreferenceForm extends StatefulWidget {
  final void Function(AnimationPreference) onPressConfirm;
  final List<CardLog> cardLogs;

  // final AnimationPreference? initialPreference;

  const PreferenceForm({super.key, required this.cardLogs, required this.onPressConfirm});

  @override
  State<PreferenceForm> createState() => _PreferenceFormState();
}

class _PreferenceFormState extends State<PreferenceForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController millisecondsController;
  late TextEditingController numColController;
  late DateTimeRange cardLogsRange;
  late DateTimeRange dateRange;

  @override
  void initState() {
    super.initState();
    final milliseconds = widget.cardLogs.length * 8;
    const numCol = 30;
    millisecondsController = TextEditingController(text: "$milliseconds");
    numColController = TextEditingController(text: "$numCol");
    cardLogsRange = _calDateTimeRangeBoundary(widget.cardLogs);
    dateRange = cardLogsRange;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: PaddedColumn(padding: 10, children: [
        TextFormField(
          controller: millisecondsController,
          decoration: const InputDecoration(suffix: Text("milliseconds")),
          validator: _validatePositiveInteger,
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                showDateRangePicker(
                  context: context,
                  initialDateRange: dateRange,
                  firstDate: cardLogsRange.start,
                  lastDate: cardLogsRange.end,
                  builder: (context, child) => FractionallySizedBox(
                    widthFactor: 0.8,
                    heightFactor: 0.8,
                    child: Theme(
                      data: ThemeData(
                        buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.accent),
                        // primaryColor: Colors.red,
                      ),
                      child: child ?? Container(),
                    ),
                  ),
                ).then((range) => setState(() {
                      if (range != null) dateRange = range;
                    }));
              },
              icon: Icon(Icons.calendar_month),
            ),
            Text("${Date.fromDateTime(dateRange.start)} to ${Date.fromDateTime(dateRange.end)}"),
          ],
        ),
        TextFormField(
          controller: numColController,
          decoration: const InputDecoration(suffix: Text("numCol")),
          validator: _validatePositiveInteger,
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // print(millisecondsController.text);
              widget.onPressConfirm(
                AnimationPreference(
                  milliseconds: int.parse(millisecondsController.text),
                  dateRange: dateRange!,
                  numCol: int.parse(numColController.text),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter the information again')),
              );
            }
          },
          child: const Text("Confirm"),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    millisecondsController.dispose();
    numColController.dispose();
    super.dispose();
  }
}

DateTimeRange _calDateTimeRangeBoundary(List<CardLog> cardLogs) {
  Date begin = Date.fromTimestamp(milliseconds: cardLogs.first.reviews.first.id);
  Date end = Date.fromTimestamp(milliseconds: cardLogs.first.reviews.first.id);
  for (final cl in cardLogs) {
    for (final r in cl.reviews) {
      final curDate = Date.fromTimestamp(milliseconds: r.id);
      if (curDate < begin) {
        begin = curDate;
      }
      if (curDate > end) {
        end = curDate;
      }
    }
  }
  return DateTimeRange(start: begin.toDateTime(), end: end.toDateTime());
}

String? _validatePositiveInteger(String? value) {
  if (value == null) {
    return "Please enter something";
  } else {
    final num = int.tryParse(value);
    if (num == null || num <= 0) {
      return "Must be a positive integer";
    }
  }
  return null;
}

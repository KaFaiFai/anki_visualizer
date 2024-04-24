import 'package:anki_progress/core/extensions.dart';
import 'package:anki_progress/models/date_range.dart';
import 'package:anki_progress/views/basic/padded_row.dart';
import 'package:flutter/material.dart';

import '../../models/animation_preference.dart';
import '../../models/card_log.dart';
import '../../models/date.dart';
import '../basic/padded_column.dart';

class PreferenceForm extends StatefulWidget {
  final void Function(AnimationPreference) onPressConfirm;
  final List<CardLog> cardLogs;

  const PreferenceForm({super.key, required this.cardLogs, required this.onPressConfirm});

  @override
  State<PreferenceForm> createState() => _PreferenceFormState();
}

class _PreferenceFormState extends State<PreferenceForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController millisecondsController;
  late TextEditingController numColController;
  late DateRange cardLogsRange;
  DateRange? dateRange;

  @override
  void initState() {
    super.initState();
    final milliseconds = (widget.cardLogs.length * 8).roundTo(1000);
    const numCol = 20;
    millisecondsController = TextEditingController(text: "$milliseconds");
    numColController = TextEditingController(text: "$numCol");
    cardLogsRange = _calDateTimeRangeBoundary(widget.cardLogs);
    dateRange = cardLogsRange;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: PaddedColumn(
        padding: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Duration"),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: millisecondsController,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    helperText: "How long for the entire animation",
                    helperStyle: Theme.of(context).textTheme.bodySmall,
                    suffixText: "ms",
                    suffixStyle: Theme.of(context).textTheme.displaySmall,
                  ),
                  validator: _validatePositiveInteger,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Number of columns"),
              SizedBox(
                width: 350,
                child: TextFormField(
                  controller: numColController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    helperText: "How many cards per row",
                    helperStyle: Theme.of(context).textTheme.bodySmall,
                  ),
                  validator: _validatePositiveInteger,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Date range"),
              OutlinedButton(
                onPressed: _pickDateRange,
                child: PaddedRow(
                  padding: 10,
                  children: [
                    const Icon(Icons.calendar_month, size: 40),
                    Text("$dateRange"),
                  ],
                ),
              ),
            ],
          ),
          FractionallySizedBox(
            widthFactor: 0.4,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(textStyle: Theme.of(context).textTheme.displayLarge),
              onPressed: _submitForm,
              child: const Text("Confirm"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    millisecondsController.dispose();
    numColController.dispose();
    super.dispose();
  }

  void _pickDateRange() {
    showDateRangePicker(
      context: context,
      initialDateRange: dateRange?.toDateTimeRange(),
      firstDate: cardLogsRange.start.toDateTime(),
      lastDate: cardLogsRange.end.toDateTime(),
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
          if (range != null) dateRange = DateRange.fromDateTimeRange(range);
        }));
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
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
  }
}

DateRange _calDateTimeRangeBoundary(List<CardLog> cardLogs) {
  Date start = Date.fromTimestamp(milliseconds: cardLogs.firstWhere((e) => e.reviews.isNotEmpty).reviews.first.id);
  Date end = Date.fromTimestamp(milliseconds: cardLogs.firstWhere((e) => e.reviews.isNotEmpty).reviews.first.id);
  for (final cl in cardLogs) {
    for (final r in cl.reviews) {
      final curDate = Date.fromTimestamp(milliseconds: r.id);
      if (curDate < start) {
        start = curDate;
      }
      if (curDate > end) {
        end = curDate;
      }
    }
  }
  return DateRange(start: start, end: end);
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

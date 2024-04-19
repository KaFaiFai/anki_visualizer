import 'package:anki_progress/models/preference.dart';
import 'package:anki_progress/view_models/preference_model.dart';
import 'package:anki_progress/views/basic/padded_column.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/card_log.dart';
import '../../models/date.dart';
import '../../view_models/data_source_model.dart';

class PreferencePage extends StatelessWidget {
  const PreferencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<DataSourceModel, PreferenceModel>(
      builder: (_, dsm, pm, __) => FutureBuilder(
        future: dsm.cardLogs,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 0.5,
              child: Center(
                child: AspectRatio(aspectRatio: 1.0, child: CircularProgressIndicator()),
              ),
            );
          }
          final cardLogs = snapshot.requireData;
          return _InputField(cardLogs, initialPreference: pm.preference);
        },
      ),
    );
  }
}

class _InputField extends StatefulWidget {
  final List<CardLog> cardLogs;
  final Preference? initialPreference;

  const _InputField(this.cardLogs, {this.initialPreference});

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  late DateTimeRange cardLogsRange;
  late Preference preference;

  @override
  void initState() {
    super.initState();
    cardLogsRange = _calDateTimeRangeBoundary(widget.cardLogs);
    if (widget.initialPreference != null) {
      preference = widget.initialPreference!;
    } else {
      final milliseconds = widget.cardLogs.length * 8;
      final dateRange = cardLogsRange;
      const numCol = 30;
      preference = Preference(milliseconds: milliseconds, dateRange: dateRange, numCol: numCol);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PaddedColumn(padding: 10, children: [
      TextField(
        controller: TextEditingController(text: "${preference.milliseconds}"),
        decoration: const InputDecoration(suffix: Text("milliseconds")),
        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
        onChanged: (text) => setState(() {
          preference.milliseconds = int.parse(text);
        }),
      ),
      Row(
        children: [
          ElevatedButton(
            onPressed: () {
              showDateRangePicker(
                context: context,
                initialDateRange: preference.dateRange,
                firstDate: cardLogsRange.start,
                lastDate: cardLogsRange.end,
                builder: (context, child) => FractionallySizedBox(
                  widthFactor: 0.5,
                  heightFactor: 0.5,
                  child: Theme(
                    data: ThemeData(
                      buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
                      // primaryColor: Colors.red,
                    ),
                    child: child ?? Container(),
                  ),
                ),
              ).then((range) => setState(() {
                    if (range != null) preference.dateRange = range;
                  }));
            },
            child: Text("Pick date range"),
          ),
          Text("${preference.dateRange}"),
        ],
      ),
      TextField(
        controller: TextEditingController(text: "${preference.numCol}"),
        decoration: const InputDecoration(suffix: Text("numCol")),
        inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
        onChanged: (text) => setState(() {
          preference.numCol = int.parse(text);
        }),
      ),
      Consumer<PreferenceModel>(
        builder: (BuildContext context, vm, Widget? child) => ElevatedButton(
          onPressed: () => vm.updatePreference(preference),
          child: Text("Confirm"),
        ),
      ),
    ]);
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

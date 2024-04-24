import 'package:anki_progress/view_models/preference_model.dart';
import 'package:anki_progress/views/basic/padded_column.dart';
import 'package:anki_progress/views/basic/text_divider.dart';
import 'package:anki_progress/views/components/exports_directory_buttons.dart';
import 'package:anki_progress/views/components/preference_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_models/data_source_model.dart';

class ConfigurationPage extends StatelessWidget {
  const ConfigurationPage({super.key});

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
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: PaddedColumn(
                padding: 20,
                children: [
                  PreferenceForm(cardLogs: cardLogs, onPressConfirm: pm.updatePreference),
                  TextDivider("Exports folder", height: 100, color: Theme.of(context).colorScheme.onSurface, space: 20),
                  const ExportsDirectoryButtons(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

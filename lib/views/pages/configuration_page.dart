import 'package:anki_progress/view_models/preference_model.dart';
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
          return Column(
            children: [
              PreferenceForm(
                cardLogs: cardLogs,
                // initialPreference: pm.preference,
                onPressConfirm: pm.updatePreference,
              ),
              const ExportsDirectoryButtons(),
            ],
          );
        },
      ),
    );
  }
}

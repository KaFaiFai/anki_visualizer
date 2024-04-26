import 'package:anki_visualizer/controller/routes.dart';
import 'package:anki_visualizer/view_models/preference_model.dart';
import 'package:anki_visualizer/views/basic/padded_column.dart';
import 'package:anki_visualizer/views/basic/text_divider.dart';
import 'package:anki_visualizer/views/components/exports_directory_buttons.dart';
import 'package:anki_visualizer/views/components/preference_form.dart';
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
            return const Center(
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 0.5,
                child: Center(child: AspectRatio(aspectRatio: 1.0, child: CircularProgressIndicator())),
              ),
            );
          }
          final cardLogs = snapshot.requireData;
          final numReviews = cardLogs.fold(0, (previousValue, element) => previousValue + element.reviews.length);
          if (numReviews == 0) {
            return const Center(child: Text("You have not learnt this deck yet."));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Align(
                // this align is to make the child SizedBox respect its width
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 1000,
                  child: PaddedColumn(
                    padding: 20,
                    children: [
                      PreferenceForm(
                          cardLogs: cardLogs,
                          onPressConfirm: (pref) {
                            pm.updatePreference(pref);
                            Navigator.pushNamed(context, Routes.cardsPage);
                          }),
                      TextDivider(
                        "Exports folder",
                        height: 100,
                        color: Theme.of(context).colorScheme.onSurface,
                        space: 40,
                      ),
                      const ExportsDirectoryButtons(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

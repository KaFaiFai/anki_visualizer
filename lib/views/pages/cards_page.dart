import 'package:anki_progress/view_models/data_source_model.dart';
import 'package:anki_progress/view_models/exports_model.dart';
import 'package:anki_progress/view_models/preference_model.dart';
import 'package:anki_progress/views/basic/capturable.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../models/animation_preference.dart';
import '../../models/card_log.dart';
import '../components/cards_grid.dart';
import '../components/cards_grid_with_control.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer3<DataSourceModel, PreferenceModel, ExportsModel>(
      builder: (_, dsm, pm, em, __) => FutureBuilder(
        future: dsm.cardLogs,
        builder: (context, snapshot) {
          final preference = pm.preference;
          if (!snapshot.hasData || preference == null) {
            return const FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 0.5,
              child: Center(
                child: AspectRatio(aspectRatio: 1.0, child: CircularProgressIndicator()),
              ),
            );
          }
          return CardsGridWithControl(
            cardLogs: snapshot.requireData,
            preference: preference,
            captureFolder: em.captureFolder,
          );
        },
      ),
    );
  }
}

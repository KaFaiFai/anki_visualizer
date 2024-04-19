import 'dart:io';

import 'package:anki_progress/view_models/data_source_model.dart';
import 'package:anki_progress/view_models/preference_model.dart';
import 'package:anki_progress/views/basic/capturable.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../models/card_log.dart';
import '../../models/preference.dart';
import '../components/cards_grid.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<DataSourceModel, PreferenceModel>(
      builder: (_, dsm, pm, __) => FutureBuilder(
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
          return GridsWithControl(cardLogs: snapshot.requireData, preference: preference);
        },
      ),
    );
  }
}

class GridsWithControl extends StatefulWidget {
  final List<CardLog> cardLogs;
  final Preference preference;

  const GridsWithControl({super.key, required this.cardLogs, required this.preference});

  @override
  State<GridsWithControl> createState() => _GridsWithControlState();
}

class _GridsWithControlState extends State<GridsWithControl> {
  final GlobalKey<CapturableState> _capturableKey = GlobalKey<CapturableState>();
  final GlobalKey<CardsGridState> _cardsGridKey = GlobalKey<CardsGridState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Capturable(
          key: _capturableKey,
          child: CardsGrid(key: _cardsGridKey, cardLogs: widget.cardLogs, preference: widget.preference),
        ),
        IconButton(
          onPressed: () {
            final folder =
                join(Platform.environment['UserProfile']!, "AndroidStudioProjects", "anki_progress", "doc", "captures");
            _cardsGridKey.currentState?.playProgress(() {
              final time = DateTime.now().millisecondsSinceEpoch;
              final saveTo = join(folder, "image-$time.png");
              _capturableKey.currentState?.captureAndSave(saveTo);
            });
          },
          icon: Icon(Icons.play_arrow),
        ),
      ],
    );
  }
}

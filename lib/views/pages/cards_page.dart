import 'package:anki_progress/view_models/data_source_model.dart';
import 'package:anki_progress/view_models/exports_model.dart';
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
          return GridsWithControl(
            cardLogs: snapshot.requireData,
            preference: preference,
            captureFolder: em.captureFolder,
          );
        },
      ),
    );
  }
}

class GridsWithControl extends StatefulWidget {
  final List<CardLog> cardLogs;
  final Preference preference;
  final String captureFolder;

  const GridsWithControl({super.key, required this.cardLogs, required this.preference, required this.captureFolder});

  @override
  State<GridsWithControl> createState() => _GridsWithControlState();
}

class _GridsWithControlState extends State<GridsWithControl> {
  final GlobalKey<CapturableState> _capturableKey = GlobalKey<CapturableState>();
  final GlobalKey<CardsGridState> _cardsGridKey = GlobalKey<CardsGridState>();
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Capturable(
          key: _capturableKey,
          child: CardsGrid(key: _cardsGridKey, cardLogs: widget.cardLogs, preference: widget.preference),
        ),
        IconButton(
          onPressed: () async {
            final begin = DateTime.now().millisecondsSinceEpoch;
            _cardsGridKey.currentState?.playProgress(() {
              final time = DateTime.now().millisecondsSinceEpoch - begin;
              final saveTo = join(widget.captureFolder, "image-${_count.toString().padLeft(7, '0')}.png");
              _capturableKey.currentState?.captureAndSave(saveTo);
              _count++;
            });
          },
          icon: Icon(Icons.play_arrow),
        ),
      ],
    );
  }
}

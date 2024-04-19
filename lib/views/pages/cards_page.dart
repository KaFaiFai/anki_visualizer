import 'package:anki_progress/view_models/data_source_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/cards_grid.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataSourceModel>(
      builder: (_, vm, __) => FutureBuilder(
        future: vm.cardLogs,
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
          return CardsGrid(cardLogs: snapshot.requireData);
        },
      ),
    );
  }
}

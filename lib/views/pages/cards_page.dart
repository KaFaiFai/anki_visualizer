import 'package:anki_progress/view_models/view_model.dart';
import 'package:anki_progress/views/widgets/cards_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ViewModel>(
      builder: (_, vm, __) => FutureBuilder(
        future: vm.cards,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const AspectRatio(aspectRatio: 1.0, child: CircularProgressIndicator());
          }
          return CardsGrid(cards: snapshot.requireData);
        },
      ),
    );
  }
}

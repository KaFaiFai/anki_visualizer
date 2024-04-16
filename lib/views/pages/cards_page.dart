import 'package:anki_progress/view_models/view_model.dart';
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
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              // mainAxisSpacing: 10,
              // crossAxisSpacing: 10,
              childAspectRatio: 1.7,
            ),
            itemCount: snapshot.requireData.length,
            itemBuilder: (BuildContext context, int index) => Text("${snapshot.requireData[index].id}"),
          );
        },
      ),
    );
  }
}

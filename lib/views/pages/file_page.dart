import 'package:anki_visualizer/controller/routes.dart';
import 'package:anki_visualizer/services/database/entities/field.dart';
import 'package:anki_visualizer/view_models/data_source_model.dart';
import 'package:anki_visualizer/views/basic/padded_column.dart';
import 'package:anki_visualizer/views/basic/padded_row.dart';
import 'package:anki_visualizer/views/run_with_app_container.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:provider/provider.dart';

import '../../services/database/entities/notetype.dart';

void main() {
  runWithAppContainer(ChangeNotifierProvider(
    create: (BuildContext context) => DataSourceModel(),
    child: const FilePage(),
  ));
}

class FilePage extends StatelessWidget {
  const FilePage({super.key});

  Widget buildHorizontalDivider(BuildContext context) {
    return Divider(height: 40, color: Theme.of(context).colorScheme.onSurface);
  }

  Widget buildVerticalDivider(BuildContext context) {
    return VerticalDivider(width: 40, color: Theme.of(context).colorScheme.onSurface);
  }

  Widget buildSelectFileRow(BuildContext context) {
    return Consumer<DataSourceModel>(
      builder: (_, dsm, __) => OutlinedButton(
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(20)),
        onPressed: () => dsm.selectFile(),
        child: PaddedRow(
          padding: 5,
          children: [
            const Icon(Icons.folder),
            Flexible(
              child: FutureBuilder(
                future: dsm.database,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text("Please pick a collection.anki2 file again");
                  }
                  return Text(dsm.selectedFile ?? "Pick your collection.anki2 file");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSelectDeckColumn(BuildContext context) {
    return Consumer<DataSourceModel>(
      builder: (_, dsm, __) => FutureBuilder(
        future: dsm.decks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return PaddedColumn(
              padding: 10,
              children: const [CircularProgressIndicator(), Text("Retrieving deck information")],
            );
          } else if (snapshot.hasError) {
            return const Text("Please pick a file again");
          } else if (!snapshot.hasData) {
            return Container();
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.only(right: 10), // to not overlap with the scrollbar
            child: PaddedColumn(
              padding: 2,
              paddingColor: Theme.of(context).colorScheme.outline,
              children: snapshot.requireData.map((deck) {
                final isSelected = dsm.selectedDeck == deck;
                return TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: isSelected ? Theme.of(context).colorScheme.background : null,
                    backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : null,
                    textStyle: Theme.of(context).textTheme.labelMedium,
                    padding: const EdgeInsets.all(15),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  onPressed: () => dsm.toggleDeck(deck),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Text(deck.name, overflow: TextOverflow.ellipsis)),
                      if (isSelected) const Icon(Icons.arrow_right),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget buildSelectFieldsColumn(BuildContext context) {
    return Consumer<DataSourceModel>(
      builder: (_, dsm, __) => FutureBuilder(
        future: Future.wait([
          dsm.fieldsInDeck ?? Future.value(<int, List<Field>>{}),
          dsm.notetypesInDeck ?? Future.value(<Notetype>[]),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return PaddedColumn(
              padding: 5,
              children: const [CircularProgressIndicator(), Text("Retrieving fields information")],
            );
          } else if (snapshot.hasError) {
            return const Text("Error occurred. Please choose a deck again");
          } else if (!snapshot.hasData) {
            return Container();
          }
          final fieldsInDeck = snapshot.requireData[0] as Map<int, List<Field>>;
          final notetypesInDeck = snapshot.requireData[1] as List<Notetype>;
          if (fieldsInDeck.isEmpty) {
            return const Text("No field detected");
          }
          return SingleChildScrollView(
            child: Column(
              children: fieldsInDeck.entries.map(
                (e) {
                  final notetypeId = e.key;
                  final notetypeName = notetypesInDeck.firstWhere((e) => e.id == notetypeId).name;
                  final fields = e.value;
                  return PaddedColumn(
                    padding: 10,
                    children: [
                      Text(notetypeName),
                      DropdownButton<Field>(
                        value: dsm.selectedFields?[notetypeId],
                        onChanged: (field) => dsm.selectField(notetypeId, field),
                        items: fields
                            .map(
                              (e) => DropdownMenuItem<Field>(
                                value: e,
                                child: Text(
                                  "${e.ord}: ${e.name}",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  );
                },
              ).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget buildNextButton(BuildContext context) {
    return Consumer<DataSourceModel>(
      builder: (_, dsm, __) => FutureBuilder(
        future: dsm.getCardLogs(),
        builder: (context, snapshot) {
          final clickable = snapshot.data ?? false;
          return FractionallySizedBox(
            widthFactor: 0.5,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(textStyle: Theme.of(context).textTheme.displayLarge),
              onPressed: clickable
                  ? () {
                      dsm.getCardLogs();
                      Navigator.pushNamed(context, Routes.configurationPage);
                    }
                  : null,
              child: const Text("Next"),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          buildSelectFileRow(context),
          buildHorizontalDivider(context),
          Expanded(
            child: Row(
              children: [
                Expanded(flex: 1, child: Center(child: buildSelectDeckColumn(context))),
                buildVerticalDivider(context),
                Expanded(flex: 1, child: Center(child: buildSelectFieldsColumn(context))),
              ],
            ),
          ),
          buildHorizontalDivider(context),
          buildNextButton(context),
        ],
      ),
    );
  }
}

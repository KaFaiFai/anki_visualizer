import 'package:anki_progress/services/database/entities/field.dart';
import 'package:anki_progress/view_models/data_source_model.dart';
import 'package:anki_progress/views/basic/padded_column.dart';
import 'package:anki_progress/views/run_with_app_container.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:provider/provider.dart';

void main() {
  runWithAppContainer(ChangeNotifierProvider(
    create: (BuildContext context) => DataSourceModel(),
    child: FilePage(),
  ));
}

class FilePage extends StatelessWidget {
  const FilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => Provider.of<DataSourceModel>(context, listen: false).selectFile(),
            child: Text("Pick a file"),
          ),
          Consumer<DataSourceModel>(
            builder: (_, dsm, __) => FutureBuilder(
              future: dsm.database,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error loading database");
                } else if (snapshot.hasData) {
                  return Text("Successfully loaded database");
                } else {
                  return Text("Please choose a database");
                }
              },
            ),
          ),
          Consumer<DataSourceModel>(
            builder: (_, dsm, __) => FutureBuilder(
              future: dsm.decks,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Wrap(
                    spacing: 30,
                    runSpacing: 10,
                    children: snapshot.requireData.map((deck) {
                      if (dsm.selectedDeck == deck) {
                        return ElevatedButton(onPressed: () => dsm.toggleDeck(deck), child: Text(deck.name));
                      } else {
                        return OutlinedButton(onPressed: () => dsm.toggleDeck(deck), child: Text(deck.name));
                      }
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text("Please select a file again");
                }
                return Text("${snapshot.hasData}");
              },
            ),
          ),
          Consumer<DataSourceModel>(
            builder: (_, dsm, __) => FutureBuilder(
              future: dsm.fieldsInDeck,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("Error getting fields in deck");
                } else if (snapshot.hasData) {
                  return Row(
                    children: snapshot.requireData.entries.map(
                      (e) {
                        final notetypeId = e.key;
                        final fields = e.value;
                        return PaddedColumn(
                          padding: 10,
                          children: [
                            Text("$notetypeId"),
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
                  );
                }
                return Container();
              },
            ),
          ),
          Consumer<DataSourceModel>(
            builder: (_, dsm, __) => FutureBuilder(
              future: dsm.getCardLogs(),
              builder: (context, snapshot) {
                final clickable = snapshot.data ?? false;
                // TODO: also reset preference
                return ElevatedButton(onPressed: clickable ? dsm.getCardLogs : null, child: Text("Next"));
              },
            ),
          ),
        ],
      ),
    );
  }
}

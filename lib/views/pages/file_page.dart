import 'dart:io';

import 'package:anki_progress/services/database/entities/field.dart';
import 'package:anki_progress/view_models/data_source_model.dart';
import 'package:anki_progress/views/basic/padded_column.dart';
import 'package:anki_progress/views/run_with_app_container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:path/path.dart';
import 'package:provider/provider.dart';

void main() {
  runWithAppContainer(ChangeNotifierProvider(
    create: (BuildContext context) => DataSourceModel(),
    child: FilePage(),
  ));
}

class FilePage extends StatelessWidget {
  static String? initialDirectory = Platform.isAndroid
      ? initialDirectory = "/storage/emulated/0/Android/data/com.ichi2.anki/files/AnkiDroid"
      : Platform.isWindows
          ? initialDirectory = join(Platform.environment['UserProfile']!, "AppData\\Roaming\\Anki2\\User 1")
          : null;

  const FilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              FilePicker.platform.pickFiles(initialDirectory: initialDirectory).then((value) {
                if (value == null) return;
                Provider.of<DataSourceModel>(context, listen: false).selectFile(value.files.single.path!);
              });
            },
            child: Text("Pick a file"),
          ),
          Consumer<DataSourceModel>(
            builder: (_, vm, __) => FutureBuilder(
              future: vm.database,
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
            builder: (_, vm, __) => FutureBuilder(
              future: vm.decks,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Wrap(
                    spacing: 30,
                    runSpacing: 10,
                    children: snapshot.requireData.map((deck) {
                      if (vm.selectedDeck == deck) {
                        return ElevatedButton(onPressed: () => vm.toggleDeck(deck), child: Text(deck.name));
                      } else {
                        return OutlinedButton(onPressed: () => vm.toggleDeck(deck), child: Text(deck.name));
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
            builder: (_, vm, __) => FutureBuilder(
              future: vm.fieldsInDeck,
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
                              value: vm.selectedFields?[notetypeId],
                              onChanged: (field) => vm.selectField(notetypeId, field),
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
            builder: (_, vm, __) => FutureBuilder(
              future: vm.getCardLogs(),
              builder: (context, snapshot) {
                final clickable = snapshot.data ?? false;
                return ElevatedButton(onPressed: clickable ? vm.getCardLogs : null, child: Text("Next"));
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:anki_progress/services/database/card.dart';
import 'package:anki_progress/view_models/view_model.dart';
import 'package:anki_progress/views/run_with_app_container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  runWithAppContainer(ChangeNotifierProvider(
    create: (BuildContext context) => ViewModel(),
    child: FilePage(),
  ));
}

class FilePage extends StatefulWidget {
  const FilePage({super.key});

  @override
  State<FilePage> createState() => _FilePageState();
}

class _FilePageState extends State<FilePage> {
  Future<Database>? database;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            String? initialDirectory;
            if (Platform.isAndroid) {
              initialDirectory = "/storage/emulated/0/Android/data/com.ichi2.anki/files/AnkiDroid";
            } else if (Platform.isWindows) {
              initialDirectory = join(Platform.environment['UserProfile']!, "AppData\\Roaming\\Anki2\\User 1");
            }
            FilePicker.platform.pickFiles(initialDirectory: initialDirectory).then((value) {
              if (value != null) {
                File file = File(value.files.single.path!);
                Provider.of<ViewModel>(context, listen: false).loadDeckNamesFromFile(file);
              }
            });
          },
          child: Text("Pick a file"),
        ),
        Selector<ViewModel, Future<List<String>>?>(
          selector: (_, vm) => vm.deckNames,
          builder: (_, deckNames, __) => FutureBuilder(
            future: deckNames,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Wrap(
                  spacing: 30,
                  runSpacing: 10,
                  children: snapshot.requireData.map((e) => Text(e)).toList(),
                );
              } else if (snapshot.hasError) {
                return Text("Please select a file again");
              }
              return Text("${snapshot.hasData}");
            },
          ),
        ),
        Container(
          color: Colors.green.withAlpha(50),
          height: 100,
        ),
        Selector<ViewModel, Future<List<Card>>?>(
          selector: (_, vm) => vm.cards,
          builder: (_, cards, __) => FutureBuilder(
            future: cards,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Wrap(
                  spacing: 30,
                  runSpacing: 10,
                  children: snapshot.requireData.map((e) => Text("${e.id}")).toList(),
                );
              } else if (snapshot.hasError) {
                return Text("Please select a file again");
              }
              return Text("${snapshot.hasData}");
            },
          ),
        )
      ],
    );
  }
}

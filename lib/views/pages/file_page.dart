import 'dart:io';

import 'package:anki_progress/view_models/selection_model.dart';
import 'package:anki_progress/views/run_with_app_container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../services/database/deck.dart';

void main() {
  runWithAppContainer(ChangeNotifierProvider(
    create: (BuildContext context) => SelectionModel(),
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
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            FilePicker.platform.pickFiles(initialDirectory: initialDirectory).then((value) {
              if (value == null) return;
              Provider.of<SelectionModel>(context, listen: false).selectFile(value.files.single.path!);
            });
          },
          child: Text("Pick a file"),
        ),
        Selector<SelectionModel, Future<List<Deck>>?>(
          selector: (_, vm) => vm.decks,
          builder: (_, deckNames, __) => FutureBuilder(
            future: deckNames,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Wrap(
                  spacing: 30,
                  runSpacing: 10,
                  children: snapshot.requireData.map((e) => Text(e.name)).toList(),
                );
              } else if (snapshot.hasError) {
                return Text("Please select a file again");
              }
              return Text("${snapshot.hasData}");
            },
          ),
        ),
      ],
    );
  }
}

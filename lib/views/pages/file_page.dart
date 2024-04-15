import 'dart:io';

import 'package:anki_progress/services/database/database_provider.dart';
import 'package:anki_progress/services/database/database_repository.dart';
import 'package:anki_progress/views/run_with_app_container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  runWithAppContainer(FilePage());
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
            FilePickerResult? result = await FilePicker.platform.pickFiles(initialDirectory: initialDirectory);

            if (result != null) {
              File file = File(result.files.single.path!);
              print(file);
              setState(() {
                database = DatabaseProvider().importDb(file);
              });
            }
          },
          child: Text("Pick a file"),
        ),
        FutureBuilder(
          future: database,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final decks = DatabaseRepository().getAllDecks(snapshot.requireData);
              return FutureBuilder(
                future: decks,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Wrap(
                      spacing: 30,
                      runSpacing: 10,
                      children: snapshot.requireData.map((e) => Text(e.name)).toList(),
                    );
                  }
                  return Container();
                },
              );
            } else if (snapshot.hasError) {
              return Text("Please select a file again");
            }
            return Text("${snapshot.hasData}");
          },
        )
      ],
    );
  }
}

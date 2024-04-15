import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('read db', () {
    test('anki', () async {
      await readAnkiDatabase();
    });
  });
}

Future<Database> openExampleDatabase() async {
  // reference: https://github.com/tekartik/sqflite/blob/master/sqflite/doc/opening_asset_db.md

  final databasesPath = await getDatabasesPath();
  final path = join(databasesPath, "demo_asset_example.db");
  print(path);

  final exists = await databaseExists(path);
  if (!exists) {
    print("Creating new copy from asset");

    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    // Copy from asset
    ByteData data = await rootBundle.load("assets/anki_database_example/collection.anki2");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write and flush the bytes written
    await File(path).writeAsBytes(bytes, flush: true);
  } else {
    print("Opening existing database");
  }

  // open the database
  final db = await openDatabase(path, readOnly: true);
  return db;
}

Future<void> readAnkiDatabase() async {
  // see https://github.com/ankidroid/Anki-Android/wiki/Database-Structure for references for each table
  final db = await openExampleDatabase();

  final cards = await db.query("cards");
  print(cards.length);
  print(cards.firstOrNull);

  final revlog = await db.query("revlog");
  print(revlog.length);
  print(revlog.firstOrNull);

  final decks = await db.query("decks");
  print(decks.length);
  print(decks.firstOrNull);

  await db.close();
}

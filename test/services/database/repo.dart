import 'dart:io';

import 'package:anki_visualizer/services/database/database_provider.dart';
import 'package:anki_visualizer/services/database/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final db = await DatabaseProvider().importDb(File("assets/anki_database_example/collection.anki2"));

  group('repo', () {
    test('getAllFieldsInDeck', () async {
      final decks = await DatabaseRepository().getAllDecks(db);
      final result = await DatabaseRepository().getAllFieldsInDeck(db, decks.last.id);
      print(result);
    });

    test('getCardField', () async {
      final result = await DatabaseRepository().getCardField(db, 1339252520793, 0);
      print(result);
    });

    test('getCardField', () async {
      final result = await DatabaseRepository().getCardReviews(db, 1339252520793);
      print(result);
    });
  });
}

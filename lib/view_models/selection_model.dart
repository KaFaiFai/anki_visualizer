import 'dart:io';

import 'package:anki_progress/models/card_log.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:sqflite/sqflite.dart';

import '../services/database/database_provider.dart';
import '../services/database/database_repository.dart';
import '../services/database/deck.dart';
import '../services/database/field.dart';

class SelectionModel extends ChangeNotifier {
  String? selectedFile;
  Deck? selectedDeck;
  Map<int, Field>? selectedFields;

  Future<Database>? database;
  Future<List<Deck>>? decks;
  Future<Map<int, List<Field>>>? fieldsInDeck;
  Future<List<CardLog>>? cardLogs;

  void selectFile(String path) {
    selectedFile = path;
    database = DatabaseProvider().importDb(File(path));
    _loadDeckNames();
    notifyListeners();
  }

  Future<void> _loadDeckNames() async {
    final db = await database;
    if (db == null) return;
    decks = DatabaseRepository().getAllDecks(db);
    notifyListeners();
  }

  void loadDeckNamesFromFile(File file) {
    DatabaseProvider().importDb(file).then((db) {
      decks = DatabaseRepository().getAllDecks(db).then((ds) {
        DatabaseRepository().getAllCardsInDeck(db, ds.last.id).then((cards) {
          cardLogs = Future(() async {
            final logs = <CardLog>[];
            for (final c in cards) {
              final text = await DatabaseRepository().getCardField(db, c.id, 1);
              final reviews = await DatabaseRepository().getCardReviews(db, c.id);
              logs.add(CardLog(text, reviews));
            }
            return logs;
          });
        });
        return ds;
      });
      notifyListeners();
    });
  }
}

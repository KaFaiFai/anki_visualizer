import 'dart:io';

import 'package:anki_progress/models/card_log.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:sqflite/sqflite.dart';

import '../services/database/database_provider.dart';
import '../services/database/database_repository.dart';
import '../services/database/entities/deck.dart';
import '../services/database/entities/field.dart';

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
    _loadDecks();
    notifyListeners();
  }

  Future<void> _loadDecks() async {
    final db = await database;
    if (db == null) return;
    decks = DatabaseRepository().getAllDecks(db);
    notifyListeners();
  }

  void toggleDeck(Deck deck) {
    selectedDeck = selectedDeck == deck ? null : deck;
    selectedFields = null;
    _loadFieldsInDeck();
    notifyListeners();
  }

  Future<void> _loadFieldsInDeck() async {
    final db = await database;
    if (db == null) return;

    final deckId = selectedDeck?.id;
    if (deckId == null) {
      fieldsInDeck = Future(() => {});
    } else {
      fieldsInDeck = DatabaseRepository().getAllFieldsInDeck(db, deckId);
    }
    // fieldsInDeck?.then((value) => print(value));
    notifyListeners();
  }

  void selectField(int notetypeId, Field? field) {
    selectedFields ??= {};
    if (field != null) selectedFields?[notetypeId] = field;
    print(selectedFields);
    notifyListeners();
  }
}

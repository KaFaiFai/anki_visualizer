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
      fieldsInDeck = null;
    } else {
      fieldsInDeck = DatabaseRepository().getAllFieldsInDeck(db, deckId);
    }
    notifyListeners();
  }

  void selectField(int notetypeId, Field? field) {
    selectedFields ??= {};
    if (field != null) selectedFields?[notetypeId] = field;
    notifyListeners();
  }

  Future<bool> getCardLogs() async {
    /// returns where this operation is valid
    ///
    final db = await database;
    final deck = selectedDeck;
    final allFieldsInDeck = (await fieldsInDeck)?.keys;
    final fields = selectedFields;
    final allFieldsSelected = allFieldsInDeck?.every((e) => fields?.keys.contains(e) ?? false) ?? false;
    if (db == null || deck == null || fields == null || !allFieldsSelected) return false;

    final cards = await DatabaseRepository().getAllCardsInDeck(db, deck.id);
    cardLogs = Future.wait(cards.map((card) async {
      final reviews = await DatabaseRepository().getCardReviews(db, card.id);
      final (mid, notes) = await DatabaseRepository().getCardNotes(db, card.id);
      final fieldOrd = fields[mid]!.ord;
      final text = notes[fieldOrd];
      return CardLog(text, reviews);
    }));

    return true;
  }
}

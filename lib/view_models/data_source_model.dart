import 'dart:io';

import 'package:anki_visualizer/core/extensions.dart';
import 'package:anki_visualizer/models/card_log.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../services/database/database_provider.dart';
import '../services/database/database_repository.dart';
import '../services/database/entities/deck.dart';
import '../services/database/entities/field.dart';
import '../services/database/entities/notetype.dart';

class DataSourceModel extends ChangeNotifier {
  static String? initialDirectory = Platform.isAndroid
      ? initialDirectory = "/storage/emulated/0/Android/data/com.ichi2.anki/files/AnkiDroid"
      : Platform.isWindows
          ? initialDirectory = join(Platform.environment['UserProfile']!, "AppData\\Roaming\\Anki2\\User 1")
          : null;

  String? selectedFile;
  Deck? selectedDeck;
  Map<int, Field>? selectedFields;

  Future<Database>? database;
  Future<List<Deck>>? decks;
  Future<Map<int, List<Field>>>? fieldsInDeck; // to store all fields in the notetype
  Future<List<Notetype>>? notetypesInDeck; // to find the name of the notetype
  Future<List<CardLog>>? cardLogs;

  void selectFile() {
    FilePicker.platform.pickFiles(initialDirectory: initialDirectory).then((value) {
      if (value == null) return;
      selectedFile = value.files.single.path;
      notifyListeners();
      database = DatabaseProvider().importDb(File(selectedFile!)).delayed();
      notifyListeners();
      _loadDecks();
    });
  }

  Future<void> _loadDecks() async {
    final db = await database;
    if (db == null) return;
    decks = DatabaseRepository().getAllDecks(db).delayed();
    notifyListeners();
  }

  void toggleDeck(Deck deck) {
    selectedDeck = selectedDeck == deck ? null : deck;
    selectedFields = null;
    notifyListeners();
    _loadFieldsInDeck().whenComplete(() {
      // assign initial value for selectedFields
      fieldsInDeck?.then((value) {
        value.forEach((key, value) {
          selectField(key, value.firstOrNull);
        });
      });
    });
  }

  Future<void> _loadFieldsInDeck() async {
    final db = await database;
    if (db == null) return;

    final deckId = selectedDeck?.id;
    if (deckId == null) {
      fieldsInDeck = null;
    } else {
      fieldsInDeck = DatabaseRepository().getAllFieldsInDeck(db, deckId).delayed();
      notetypesInDeck = DatabaseRepository().getAllNotetypesInDeck(db, deckId).delayed();
    }
    notifyListeners();
  }

  void selectField(int notetypeId, Field? field) {
    selectedFields ??= {};
    if (field != null) selectedFields?[notetypeId] = field;
    notifyListeners();
  }

  Future<bool> getCardLogs() async {
    /// returns whether this operation is valid

    final db = await database;
    final deck = selectedDeck;
    final allFieldsInDeck = (await fieldsInDeck)?.keys;
    final fields = selectedFields;
    final allFieldsSelected = allFieldsInDeck?.every((e) => fields?.keys.contains(e) ?? false) ?? false;
    if (db == null || deck == null || fields == null || fields.isEmpty || !allFieldsSelected) return false;

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

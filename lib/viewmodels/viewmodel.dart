import 'dart:io';

import 'package:flutter/material.dart' hide Card;

import '../services/database/card.dart';
import '../services/database/database_provider.dart';
import '../services/database/database_repository.dart';

class Viewmodel extends ChangeNotifier {
  Future<List<String>>? deckNames;
  Future<List<Card>>? cards;

  void loadDeckNamesFromFile(File file) {
    DatabaseProvider().importDb(file).then((db) {
      final decks = DatabaseRepository().getAllDecks(db);
      deckNames = decks.then((ds) {
        cards = DatabaseRepository().getAllCardsInDeck(db, ds[2].id);
        return ds.map((e) => e.name).toList();
      });
      notifyListeners();
    });
  }
}

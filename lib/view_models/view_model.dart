import 'dart:io';

import 'package:anki_progress/models/card_log.dart';
import 'package:flutter/material.dart' hide Card;

import '../services/database/database_provider.dart';
import '../services/database/database_repository.dart';
import '../services/database/field.dart';

class ViewModel extends ChangeNotifier {
  Future<List<String>>? deckNames;
  Future<Map<int, List<Field>>>? fieldsInDeck;
  Future<List<CardLog>>? cardLogs;

  void loadDeckNamesFromFile(File file) {
    DatabaseProvider().importDb(file).then((db) {
      final decks = DatabaseRepository().getAllDecks(db);
      deckNames = decks.then((ds) {
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
        return ds.map((e) => e.name).toList();
      });
      notifyListeners();
    });
  }
}

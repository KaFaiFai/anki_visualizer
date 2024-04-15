import 'dart:io';

import 'package:flutter/material.dart';

import '../services/database/database_provider.dart';
import '../services/database/database_repository.dart';

class Viewmodel extends ChangeNotifier {
  Future<List<String>>? deckNames;

  void loadDeckNamesFromFile(File file) {
    deckNames = DatabaseProvider().importDb(file).then((value) {
      final decks = DatabaseRepository().getAllDecks(value);
      return decks.then((value) => value.map((e) => e.name).toList());
    });
    notifyListeners();
  }
}

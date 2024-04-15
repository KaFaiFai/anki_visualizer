import 'package:anki_progress/services/database/card.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'deck.dart';

class DatabaseRepository {
  Future<List<Deck>> getAllDecks(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('decks');
    return List.generate(maps.length, (i) {
      return Deck.fromMap(maps[i]);
    });
  }

  Future<List<Card>> getAllCardsInDeck(Database db, int deckId) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'cards',
      where: 'did = ?',
      whereArgs: [deckId],
      orderBy: "ord",
    );
    return List.generate(maps.length, (i) {
      return Card.fromMap(maps[i]);
    });
  }
}

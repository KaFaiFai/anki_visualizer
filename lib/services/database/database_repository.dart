import 'package:anki_progress/services/database/card.dart';
import 'package:anki_progress/services/database/field.dart';
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

  Future<Map<int, List<Field>>> getAllFieldsInDeck(Database db, int deckId) async {
    /// Get all appeared note types and their fields in the deck

    final sqlGetNotetypeId = """
        SELECT mid
				FROM cards
				LEFT JOIN notes ON cards.nid = notes.id
				WHERE cards.did = $deckId
				GROUP BY notes.mid
				""";
    final sqlGetFields = """
        SELECT *
        FROM fields
        WHERE ntid in ($sqlGetNotetypeId)
        ORDER BY ord
        """;

    final List<Map<String, dynamic>> maps = await db.rawQuery(sqlGetFields);

    final notetypeIdToFields = <int, List<Field>>{};
    for (final m in maps) {
      notetypeIdToFields.update(m["ntid"], (value) => value..add(Field.fromMap(m)), ifAbsent: () => [Field.fromMap(m)]);
    }
    return notetypeIdToFields;
  }

  Future<String> getNotetypeName(Database db, int notetypeId) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'notetypes',
      where: 'id = ?',
      whereArgs: [notetypeId],
    );
    return maps.single["name"];
  }
}

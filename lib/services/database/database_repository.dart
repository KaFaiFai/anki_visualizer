import 'dart:ffi';

import 'package:anki_progress/services/database/entities/card.dart';
import 'package:anki_progress/services/database/entities/field.dart';
import 'package:anki_progress/services/database/entities/review.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'entities/deck.dart';

class DatabaseRepository {
  Future<List<Deck>> getAllDecks(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('decks');
    return maps.map((e) => Deck.fromMap(e)).toList();
  }

  Future<List<Card>> getAllCardsInDeck(Database db, int deckId) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'cards',
      where: 'did = ?',
      whereArgs: [deckId],
      orderBy: "ord",
    );
    return maps.map((e) => Card.fromMap(e)).toList();
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

  // Future<Notetype> getNotetype(Database db, int notetypeId) async {
  //   final List<Map<String, dynamic>> maps = await db.query(
  //     'notetypes',
  //     where: 'id = ?',
  //     whereArgs: [notetypeId],
  //   );
  //   return Notetype.fromMap(maps.single);
  // }

  Future<(int, List<String>)> getCardNotes(Database db, int cardId) async {
    // Get mid and flds in this note of the card. separated by 0x1f (31) character

    final sqlGetCardFlds = """
        SELECT mid, flds
				FROM cards
				LEFT JOIN notes ON cards.nid = notes.id
				WHERE cards.id = $cardId
				""";
    final List<Map<String, dynamic>> maps = await db.rawQuery(sqlGetCardFlds);
    final mid = maps.single["mid"] as int;
    final notes = (maps.single["flds"] as String).split(String.fromCharCode(31));
    return (mid, notes);
  }

  Future<String> getCardField(Database db, int cardId, int fieldOrd) async {
    final sqlGetNotetypeId = """
        SELECT flds
				FROM cards
				LEFT JOIN notes ON cards.nid = notes.id
				WHERE cards.id = $cardId
				GROUP BY notes.mid
				""";
    final List<Map<String, dynamic>> maps = await db.rawQuery(sqlGetNotetypeId);
    final fields = (maps.single["flds"] as String).split(String.fromCharCode(31));
    return fields[fieldOrd];
  }

  Future<List<Review>> getCardReviews(Database db, int cardId) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'revlog',
      where: 'cid = ?',
      whereArgs: [cardId],
      orderBy: "id",
    );
    return maps.map((e) => Review.fromMap(e)).toList();
  }
}

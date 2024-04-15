import 'package:anki_progress/services/database/card.dart';

import 'database_provider.dart';

class DatabaseDao {
  static final instance = DatabaseDao._init();
  final _database = DatabaseProvider.database;

  DatabaseDao._init();

  Future<List<Card>> getAllCards() async {
    final db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('cards');
    return List.generate(maps.length, (i) {
      return Card.fromMap(maps[i]);
    });
  }
}

import 'package:anki_progress/services/database/card.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'database_provider.dart';

mixin DatabaseDao on DatabaseProvider {
  Future<List<Card>> getAllCards(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('cards');
    return List.generate(maps.length, (i) {
      return Card.fromMap(maps[i]);
    });
  }
}

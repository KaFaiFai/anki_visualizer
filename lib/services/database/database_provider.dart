import 'dart:io';

import 'package:anki_visualizer/models/log.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseProvider {
  static Future<String> _getDbPath() async {
    String folderPath = await getDatabasesPath();
    final path = join(folderPath, 'anki_visualizer.db');
    return path;
  }

  Database? database;

  Future<Database> importDb(File from) async {
    await database?.close();
    await _copyDb(from);
    database = await _openDb();
    final tables = await database?.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');
    final tableNames = tables?.map((e) => e["tbl_name"]).toSet().join(", ");
    Log.logger.d("All tables: $tableNames");
    return database!;
  }

  Future<Database?> openDbIfExist() async {
    if (database != null) {
      return database;
    }
    final path = await _getDbPath();
    final exists = await databaseExists(path);
    if (exists) {
      return await _openDb();
    }
    return null;
  }

  Future<Database> _openDb() async {
    final path = await _getDbPath();
    return await openDatabase(path, version: 1);
  }

  Future<void> _copyDb(File from) async {
    // copy the selected file into the app's database path
    final path = await _getDbPath();
    Log.logger.i("Saving database to $path");

    final exists = await databaseExists(path);
    if (exists) {
      Log.logger.t("Deleting existing database");
      deleteDatabase(path);
    }

    Log.logger.t("Creating database copy");
    Directory(dirname(path)).createSync(recursive: true);

    final data = await from.readAsBytes();
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(path).writeAsBytes(bytes, flush: true);
  }
}

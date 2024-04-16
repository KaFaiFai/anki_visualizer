import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseProvider {
  static Future<String> _getDbPath() async {
    String folderPath = await getDatabasesPath();
    final path = join(folderPath, 'anki_progress.db');
    return path;
  }

  Database? database;

  Future<Database> importDb(File from) async {
    await database?.close();
    await _copyDb(from);
    database = await _openDb();
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
    return await openDatabase(path, version: 1, readOnly: true);
  }

  Future<void> _copyDb(File from) async {
    final path = await _getDbPath();

    final exists = await databaseExists(path);
    if (exists) {
      print("Deleting existing database");
      deleteDatabase(path);
    }

    print("Creating database copy");
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    final data = await from.readAsBytes();
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(path).writeAsBytes(bytes, flush: true);
  }
}

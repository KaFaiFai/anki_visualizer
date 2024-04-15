import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseProvider {
  static Future<String> _getDbPath() async {
    String folderPath = await getDatabasesPath();
    final path = join(folderPath, 'anki_progress.db');
    return path;
  }

  DatabaseProvider();

  Database? database;

  Future<Database> importDb(String from) async {
    await database?.close();
    await _copyDb(from);
    database = await _openDb();
    return database!;
  }

  Future<Database> _openDb() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final path = await _getDbPath();
    return await openDatabase(path, version: 1, readOnly: true);
  }

  Future<void> _copyDb(String from) async {
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

    ByteData data = await rootBundle.load(from);
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(path).writeAsBytes(bytes, flush: true);
  }
}

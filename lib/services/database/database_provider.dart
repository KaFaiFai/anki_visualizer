import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

const databasePath = 'anki_progress.db';

class DatabaseProvider {
  DatabaseProvider._();

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  static Future<String> _getDbPath() async {
    String folderPath = await getDatabasesPath();
    if (!kIsWeb && Platform.isWindows) {
      // https://stackoverflow.com/questions/25498128/how-do-i-tell-where-the-users-home-directory-is-in-dart
      folderPath = join(Platform.environment['UserProfile']!, "Documents", "AnkiProgress");
    }
    final path = join(folderPath, databasePath);
    return path;
  }

  static Future<Database> _initDb() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final String path = await _getDbPath();
    return await openDatabase(
      path,
      version: 1,
      readOnly: true,
    );
  }
}

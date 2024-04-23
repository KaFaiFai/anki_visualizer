import 'dart:io';

import 'package:anki_progress/core/values.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Values.init();
  if (Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}

import 'dart:io';

import 'package:anki_visualizer/core/values.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// setup for non-web application
Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Values.init();
  if (Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}

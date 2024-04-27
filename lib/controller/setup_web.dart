import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../core/values.dart';

// setup for web application
Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Values.init();
  usePathUrlStrategy();
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }
}

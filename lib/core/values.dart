import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Values {
  static late final Directory userDirectory;

  static Future<void> init() async {
    userDirectory = await getApplicationDocumentsDirectory();
  }
}

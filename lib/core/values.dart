import 'dart:ui';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Values {
  Values._();

  static late final String appDirectory;

  static Future<void> init() async {
    final userDirectory = await getApplicationDocumentsDirectory();
    appDirectory = join(userDirectory.path, "Anki Visualizer");
  }

  static const easyColor = Color(0xFF006CFF);
  static const goodColor = Color(0xFF04AC04);
  static const hardColor = Color(0xFFCA7700);
  static const againColor = Color(0xFFAC3134);
}

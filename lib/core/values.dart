import 'dart:ui';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Values {
  Values._();

  static late final String appDirectory;
  static late final String version;
  static late final String buildNumber;

  static Future<void> init() async {
    final userDirectory = await getApplicationDocumentsDirectory();
    appDirectory = join(userDirectory.path, "Anki Visualizer");

    final info = await PackageInfo.fromPlatform();
    version = info.version;
    buildNumber = info.buildNumber;
  }

  static const easyColor = Color(0xFF006CFF);
  static const goodColor = Color(0xFF04AC04);
  static const hardColor = Color(0xFFCA7700);
  static const againColor = Color(0xFFAC3134);
}

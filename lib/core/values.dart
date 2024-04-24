import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Values {
  static late final String appDirectory;

  static Future<void> init() async {
    final userDirectory = await getApplicationDocumentsDirectory();
    appDirectory = join(userDirectory.path, "Anki Visualizer");
  }
}

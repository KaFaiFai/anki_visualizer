import 'dart:io';

import 'package:anki_visualizer/core/extensions.dart';
import 'package:anki_visualizer/core/values.dart';
import 'package:archive/archive_io.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';

enum FFmpegInstallerState { none, downloading, unzipping, completed , error}

class FFmpegInstaller {
  static const windowsBuildPath = "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip";

  static String get downloadTo {
    return join(Values.appDirectory, "tools", "ffmpeg.zip");
  }

  static String get unzipTo {
    return join(Values.appDirectory, "tools", "ffmpeg");
  }

  Future<void> download() async {
    var req = await get(Uri.parse(windowsBuildPath));
    var file = File(downloadTo)..deleteIfExistsAndCreateParents();
    await file.writeAsBytes(req.bodyBytes);
  }

  // Unarchive and save the file in Documents directory and save the paths in the array
  Future<void> unzip() async {
    File(unzipTo).deleteIfExistsAndCreateParents();
    await extractFileToDisk(downloadTo, unzipTo);
  }

  String? getFFmpegPath() {
    final folder = Directory(unzipTo);
    if(!folder.existsSync()) return null;

    final exePath = join(folder.listSync().single.path, "bin", "ffmpeg.exe");
    if (File(exePath).existsSync()) return exePath;
    return null;
  }
}

import 'dart:io';

import 'package:anki_progress/core/extensions.dart';
import 'package:anki_progress/core/values.dart';
import 'package:archive/archive_io.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';

class FFmpegInstaller {
  static const windowsBuildPath = "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip";

  String get downloadTo {
    return join(Values.userDirectory.path, "anki_visualize", "tools", "ffmpeg.zip");
  }

  String get unzipTo {
    return join(Values.userDirectory.path, "anki_visualize", "tools", "ffmpeg");
  }

  Future<void> download() async {
    print("Download to $downloadTo}");
    var req = await get(Uri.parse(windowsBuildPath));
    var file = File(downloadTo)..deleteIfExistsAndCreateParents;
    await file.writeAsBytes(req.bodyBytes);
    print("Download completed");
  }

  // Unarchive and save the file in Documents directory and save the paths in the array
  Future<void> unzip() async {
    print("Unzip to $unzipTo}");
    File(unzipTo).deleteIfExistsAndCreateParents();
    await extractFileToDisk(downloadTo, unzipTo);
    print("Unzip completed");
  }

  String? getFFmpegPath() {
    final folder = Directory(unzipTo);
    final exePath = join(folder.listSync().single.path, "bin", "ffmpeg.exe");
    if (File(exePath).existsSync()) return exePath;
    return null;
  }
}

import 'dart:io';

import 'package:anki_progress/core/values.dart';
import 'package:anki_progress/services/internet/ffmpeg_installer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class ExportsModel extends ChangeNotifier {
  late String captureRootFolder;
  late String captureFolder; // temp folder to store individual images
  late String videosFolder;

  Future<ProcessResult>? exportVideoResult;
  Future<ProcessResult>? exportGIFResult;

  ExportsModel() {
    _init();
  }

  void _init() {
    final directory = Values.userDirectory;
    captureRootFolder = join(directory.path, "anki_visualize", "captures");
    _updateCaptureFolder(captureRootFolder);
    final videosRootFolder = join(directory.path, "anki_visualize", "videos");
    _updateVideosFolder(videosRootFolder);
  }

  void selectCaptureRootFolder() {
    FilePicker.platform.getDirectoryPath(initialDirectory: captureRootFolder).then((value) {
      if (value == null) return;
      _updateCaptureFolder(value);
    });
  }

  Future<void> _updateCaptureFolder(String rootFolder) async {
    captureRootFolder = rootFolder;
    captureFolder = join(rootFolder, Uuid().v4());
    await Directory(captureFolder).create(recursive: true);
    print("Captures are saved to $captureFolder");
    notifyListeners();
  }

  void selectVideosFolder() {
    FilePicker.platform.getDirectoryPath(initialDirectory: videosFolder).then((value) {
      if (value == null) return;
      _updateVideosFolder(value);
    });
  }

  Future<void> _updateVideosFolder(String folder) async {
    videosFolder = folder;
    await Directory(videosFolder).create(recursive: true);
    print("Videos are saved to $videosFolder");
    notifyListeners();
  }

  void exportVideo() {
    // ffmpeg.exe -framerate 24 -i {{captureFolder}}\image-%7d.png {{videosFolder}}\output.mp4
    final ffmpegPath = _getFFmpegPath();
    final imagesPath = join(captureFolder, "image-%7d.png");
    final exportPath = join(videosFolder, "output.mp4");
    exportVideoResult = Process.run(ffmpegPath, ["-framerate", "24", "-i", imagesPath, exportPath]);
    exportVideoResult?.then((_) => print("Exported video to $exportPath"));
    notifyListeners();
  }

  Future<void> exportGIF() async {
    // ffmpeg.exe -i {{captureFolder}}\image-%7d.png {{videosFolder}}\output.gif
    final ffmpegPath = _getFFmpegPath();
    final imagesPath = join(captureFolder, "image-%7d.png");
    final exportPath = join(videosFolder, "output.gif");
    exportGIFResult = Process.run(ffmpegPath, ["-i", imagesPath, exportPath]);
    exportGIFResult?.then((_) => print("Exported gif to $exportPath"));
    notifyListeners();
  }
}

String _getFFmpegPath() {
  final ffmpegPath = FFmpegInstaller().getFFmpegPath();
  if (ffmpegPath != null) {
    return ffmpegPath;
  } else {
    throw UnimplementedError("$defaultTargetPlatform not supported");
  }
}

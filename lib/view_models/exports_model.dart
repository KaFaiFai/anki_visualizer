import 'dart:io';

import 'package:anki_progress/core/extensions.dart';
import 'package:anki_progress/core/values.dart';
import 'package:anki_progress/models/export_format.dart';
import 'package:anki_progress/services/internet/ffmpeg_installer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class ExportsModel extends ChangeNotifier {
  late String captureRootFolder;
  late String captureFolder; // temp folder to store individual images
  late String videosFolder;

  late bool isFFmpegAvailable;

  FFmpegInstallerState ffmpegInstallerState = FFmpegInstallerState.none;
  ExportFormat format = ExportFormat.gif;
  Future<ProcessResult>? exportResult;

  ExportsModel() {
    _init();
  }

  void _init() {
    final directory = Values.appDirectory;
    captureRootFolder = join(directory, "captures");
    _updateCaptureFolder(captureRootFolder);
    final videosRootFolder = join(directory, "videos");
    _updateVideosFolder(videosRootFolder);
    updateFFmpegAvailable();
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
    print("Videos are saved to $videosFolder");
    notifyListeners();
  }

  void updateFFmpegAvailable() {
    isFFmpegAvailable = FFmpegInstaller().getFFmpegPath() != null;
    notifyListeners();
  }

  void updateFFmpegInstallerState(FFmpegInstallerState state) {
    ffmpegInstallerState = state;
    notifyListeners();
  }

  Future<void> installFFmpeg() async {
    try {
      final installer = FFmpegInstaller();
      updateFFmpegInstallerState(FFmpegInstallerState.downloading);
      await installer.download();
      updateFFmpegInstallerState(FFmpegInstallerState.unzipping);
      await installer.unzip();
      await File(FFmpegInstaller.downloadTo).delete();
      updateFFmpegInstallerState(FFmpegInstallerState.completed);
    } catch (e) {
      updateFFmpegInstallerState(FFmpegInstallerState.error);
    }
    updateFFmpegAvailable();
  }

  void updateExportFormat(ExportFormat? exportFormat) {
    format = exportFormat ?? format;
    notifyListeners();
  }

  void export() {
    switch (format) {
      case ExportFormat.gif:
        exportResult = _exportGIF();
      case ExportFormat.mp4:
        exportResult = _exportVideo();
    }
    exportResult?.whenComplete(() => print("Exported ${format.name} to $videosFolder"));
    notifyListeners();
  }

  Future<ProcessResult>? _exportVideo() {
    // ffmpeg.exe -framerate 24 -i {{captureFolder}}\image-%7d.png {{videosFolder}}\output.mp4
    final ffmpegPath = _getFFmpegPath();
    final imagesPath = join(captureFolder, "image-%7d.png");
    final exportPath = join(videosFolder, "output.mp4");
    File(exportPath).deleteIfExistsAndCreateParents();
    return Process.run(ffmpegPath, ["-framerate", "24", "-i", imagesPath, exportPath]);
  }

  Future<ProcessResult>? _exportGIF() {
    // ffmpeg.exe -i {{captureFolder}}\image-%7d.png {{videosFolder}}\output.gif
    final ffmpegPath = _getFFmpegPath();
    final imagesPath = join(captureFolder, "image-%7d.png");
    final exportPath = join(videosFolder, "output.gif");
    File(exportPath).deleteIfExistsAndCreateParents();
    return Process.run(ffmpegPath, ["-i", imagesPath, exportPath]);
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

import 'dart:io';

import 'package:anki_visualizer/core/extensions.dart';
import 'package:anki_visualizer/core/values.dart';
import 'package:anki_visualizer/models/export_options.dart';
import 'package:anki_visualizer/services/internet/ffmpeg_installer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import '../models/log.dart';

class ExportsModel extends ChangeNotifier {
  late String captureRootFolder;
  late String captureFolder; // temp folder to store individual images
  String? videoFile;

  late bool isFFmpegAvailable;

  FFmpegInstallerState ffmpegInstallerState = FFmpegInstallerState.none;
  ExportOptions exportOptions = const ExportOptions();
  Future<ProcessResult>? exportResult;

  ExportsModel() {
    _init();
  }

  void _init() {
    final directory = Values.appDirectory;
    captureRootFolder = join(directory, "captures");
    _updateCaptureFolder(captureRootFolder);
    updateFFmpegAvailable();
  }

  void selectCaptureRootFolder() {
    Directory(captureRootFolder).createIfNotExists();
    FilePicker.platform.getDirectoryPath(initialDirectory: captureRootFolder).then((value) {
      if (value == null) return;
      _updateCaptureFolder(value);
    });
  }

  Future<void> _updateCaptureFolder(String rootFolder) async {
    captureRootFolder = rootFolder;
    captureFolder = join(rootFolder, const Uuid().v4());
    Log.logger.i("Captures are saved to $captureFolder");
    notifyListeners();
  }

  Future<String?> selectVideoFile() {
    final videosRootFolder = join(Values.appDirectory, "videos");
    Directory(videosRootFolder).createIfNotExists();
    return FilePicker.platform.saveFile(
      fileName: "output.${exportOptions.format.name}",
      initialDirectory: videosRootFolder,
    );
  }

  Future<void> updateVideoFile(String file) async {
    videoFile = file;
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

  void updateExportOptions(ExportOptions options) {
    exportOptions = options;
    notifyListeners();
  }

  void export() {
    final outputFile = videoFile;
    if (outputFile == null) return;

    // cmd: ffmpeg.exe -framerate 15 -i {{captureFolder}}\image-%7d.png {{videosFolder}}\output.mp4
    final ffmpegPath = _getFFmpegPath();
    final imagesPath = join(captureFolder, "image-%7d.png");
    File(outputFile).deleteIfExistsAndCreateParents();
    exportResult = Process.run(ffmpegPath, ["-framerate", "${exportOptions.framerate}", "-i", imagesPath, outputFile]);
    exportResult?.whenComplete(() => Log.logger.i("Exported ${exportOptions.format.name} to $videoFile"));
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

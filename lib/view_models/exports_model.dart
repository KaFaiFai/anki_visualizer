import 'dart:io';

import 'package:anki_progress/core/values.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class ExportsModel extends ChangeNotifier {
  late String captureRootFolder;
  late String captureFolder; // temp folder to store individual images
  late String videosFolder;

  Future<bool>? exportGIFState;

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
    // TODO: convert images to video format
    return;
    // ffmpeg.exe -i {{captureFolder}}\image-%7d.png {{videosFolder}}\output.mp4
  }

  Future<void> exportGIF() async {
    // ffmpeg.exe -i {{captureFolder}}\image-%7d.png {{videosFolder}}\output.gif

    final files = Directory(captureFolder).listSync();
    final decodeImages = files.map((e) => decodePngFile(e.path));
    final images = await Future.wait(decodeImages).then((images) => images.nonNulls);
    final animation = images.reduce((image, nextImage) => image..addFrame(nextImage));

    final exportPath = join(videosFolder, "output.gif");
    if (File(exportPath).existsSync()) File(exportPath).deleteSync();
    // TODO: faster export
    exportGIFState = encodeGifFile(exportPath, animation, samplingFactor: 100);
    notifyListeners();
    exportGIFState?.then((_) => print("Exported gif to $exportPath"));
  }

  Future<void> exportGIFWithFFMpeg() async {
    const ffmpegPath = "C:\\insert\\link\\to\\bin\\ffmpeg.exe";
    final imagesPath = join(captureFolder, "image-%7d.png");
    final exportPath = join(videosFolder, "output.gif");
    await Process.run(ffmpegPath, ["-i", imagesPath, exportPath]);
    notifyListeners();
  }
}

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
  late String exportsFolder;

  Future<bool>? exportGIFState;

  ExportsModel() {
    _init();
  }

  void _init() {
    final directory = Values.userDirectory;
    captureRootFolder = join(directory.path, "anki_visualize", "captures");
    _updateCaptureFolder(captureRootFolder);
    final exportsRootFolder = join(directory.path, "anki_visualize", "exports");
    _updateExportsFolder(exportsRootFolder);
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

  void selectExportsFolder() {
    FilePicker.platform.getDirectoryPath(initialDirectory: exportsFolder).then((value) {
      if (value == null) return;
      _updateExportsFolder(value);
    });
  }

  Future<void> _updateExportsFolder(String folder) async {
    exportsFolder = folder;
    await Directory(exportsFolder).create(recursive: true);
    print("Exports are saved to $exportsFolder");
    notifyListeners();
  }

  void exportVideo() {
    // TODO: convert images to video format
    return;
    // ffmpeg.exe -i {{captureFolder}}\image-%d.png {{exportsFolder}}\output.mp4
  }

  Future<void> exportGIF() async {
    // ffmpeg.exe -i {{captureFolder}}\image-%d.png {{exportsFolder}}\output.gif

    final files = Directory(captureFolder).listSync();
    final decodeImages = files.map((e) => decodePngFile(e.path));
    final images = await Future.wait(decodeImages).then((images) => images.nonNulls);
    final animation = images.reduce((image, nextImage) => image..addFrame(nextImage));

    final exportPath = join(exportsFolder, "output.gif");
    File(exportPath).deleteSync();
    // TODO: faster export
    exportGIFState = encodeGifFile(exportPath, animation);
    notifyListeners();
    exportGIFState?.then((_) => print("Exported gif to $exportPath"));
  }
}

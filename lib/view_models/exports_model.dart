import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ExportsModel extends ChangeNotifier {
  late String captureRootFolder;
  late String captureFolder; // temp folder to store individual images
  late String exportsFolder;

  Future<bool>? exportGIFState;

  ExportsModel() {
    _init();
  }

  Future<void> _init() async {
    final directory = await getApplicationDocumentsDirectory();
    captureRootFolder = join(directory.path, "captures");
    _updateCaptureFolder(captureRootFolder);
    final exportsRootFolder = join(directory.path, "exports");
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
    // print(files);
    final image = await decodePngFile(files.first.path);
    if (image != null) {
      for (var i = 1; i < files.length; i++) {
        final newImage = await decodePngFile(files[i].path);
        if (newImage != null) image.addFrame(newImage);
      }
      final exportPath = join(exportsFolder, "output.gif");
      File(exportPath).deleteSync();
      exportGIFState = encodeGifFile(exportPath, image);
      notifyListeners();
      exportGIFState?.then((_) => print("Exported gif to $exportPath"));
    }
  }
}

import 'dart:io';

import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ExportsModel extends ChangeNotifier {
  late String captureFolder; // temp folder to store individual images
  late String exportsFolder;

  ExportsModel() {
    _init();
  }

  Future<void> _init() async {
    final directory = await getApplicationDocumentsDirectory();
    final captureRootFolder = join(directory.path, "captures");
    updateCaptureFolder(captureRootFolder);
    final exportsRootFolder = join(directory.path, "exports");
    updateExportsFile(exportsRootFolder);
  }

  Future<void> updateCaptureFolder(String rootFolder) async {
    captureFolder = join(rootFolder, Uuid().v4());
    await Directory(captureFolder).create(recursive: true);
    print("Captures are saved to $captureFolder");
    notifyListeners();
  }

  Future<void> updateExportsFile(String folder) async {
    exportsFolder = folder;
    await Directory(exportsFolder).create(recursive: true);
    print("Exports are saved to $exportsFolder");
    notifyListeners();
  }

  void exportVideo() {
    // ffmpeg.exe -i {{captureFolder}}\image-%d.png {{exportsFolder}}\output.mp4
    FFmpegKit.execute('-i $captureFolder\\image-%d.png $exportsFolder\\output.mp4').then((session) async {
      final returnCode = await session.getReturnCode();
      print(returnCode);
    });
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
      await encodeGifFile(exportPath, image);
      print("Exported gif to $exportPath");
    }
  }
}

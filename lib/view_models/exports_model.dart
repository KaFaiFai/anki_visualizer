import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ExportsModel extends ChangeNotifier {
  late String captureFolder; // temp folder to store individual images
  late String exportsFile;

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
    exportsFile = folder;
    await Directory(exportsFile).create(recursive: true);
    print("Exports are saved to $exportsFile");
    notifyListeners();
  }

  void exports() {}
}

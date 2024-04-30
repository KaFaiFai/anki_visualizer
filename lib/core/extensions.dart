import 'dart:io';

import 'package:flutter/foundation.dart';

extension FutureExtension<T> on Future<T> {
  Future<T> delayed([Duration duration = const Duration(seconds: 1)]) {
    // to simulate when the process is long
    return Future.delayed(kReleaseMode ? Duration.zero : duration, () => this);
  }
}

extension IntExtension on int {
  int roundTo(int nearest) {
    return (this / nearest).round() * nearest;
  }
}

extension FileExtension on File {
  void deleteIfExistsAndCreateParents() {
    if (existsSync()) deleteSync();
    parent.createSync(recursive: true);
  }
}

extension DirectoryExtension on Directory {
  void createIfNotExists() {
    if (!existsSync()) createSync(recursive: true);
  }
}

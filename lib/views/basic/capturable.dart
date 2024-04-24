import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:anki_progress/core/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// reference: https://stackoverflow.com/questions/66809587/flutter-can-we-save-a-canvas-custompainter-to-a-gif-or-continuous-pictures-or-e
class Capturable extends StatefulWidget {
  final Widget child;

  const Capturable({super.key, required this.child});

  @override
  State<Capturable> createState() => CapturableState();
}

class CapturableState extends State<Capturable> {
  final GlobalKey _globalKey = GlobalKey();

  Future<Uint8List> _capturePng() async {
    final RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();
    return pngBytes;
  }

  Future<void> _saveBytes(Uint8List imageBytes, String path) async {
    final file = File(path)..deleteIfExistsAndCreateParents();
    file.create();
    return file.writeAsBytesSync(imageBytes);
  }

  void captureAndSave(String path) {
    _capturePng().then((value) => _saveBytes(value, path));
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _globalKey,
      child: widget.child,
    );
  }
}

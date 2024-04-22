import 'package:anki_progress/view_models/exports_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Provider.of<ExportsModel>(context, listen: false).exportVideo();
          },
          child: Text("Export to video"),
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<ExportsModel>(context, listen: false).exportGIF();
          },
          child: Text("Export to gif"),
        ),
      ],
    );
  }
}

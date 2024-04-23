import 'package:anki_progress/views/basic/padded_column.dart';
import 'package:anki_progress/views/basic/padded_row.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';

import '../../view_models/exports_model.dart';

class ExportsDirectoryButtons extends StatelessWidget {
  const ExportsDirectoryButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return PaddedColumn(
      padding: 20,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Saved captures to"),
            Consumer<ExportsModel>(
              builder: (_, em, __) => PaddedRow(
                padding: 10,
                children: [
                  IconButton(
                    onPressed: () => OpenFilex.open(em.captureRootFolder),
                    icon: const Icon(Icons.folder_copy),
                  ),
                  ElevatedButton(
                    onPressed: () => em.selectCaptureRootFolder(),
                    child: Text(em.captureRootFolder),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Save videos to"),
            Consumer<ExportsModel>(
              builder: (_, em, __) => PaddedRow(
                padding: 10,
                children: [
                  IconButton(
                    onPressed: () => OpenFilex.open(em.videosFolder),
                    icon: const Icon(Icons.folder_copy),
                  ),
                  ElevatedButton(
                    onPressed: () => em.selectVideosFolder(),
                    child: Text(em.videosFolder),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:anki_visualizer/views/basic/padded_column.dart';
import 'package:anki_visualizer/views/basic/padded_row.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';

import '../../view_models/exports_model.dart';

class ExportsDirectoryButtons extends StatelessWidget {
  const ExportsDirectoryButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return PaddedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      padding: 10,
      children: [
        const Text("Saved captures to"),
        Text(
          "This folder is used to temporarily store screenshots during animation"
          " which can be later exported into gif or video format."
          " Please clean up this when you are done.",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
        ),
        Consumer<ExportsModel>(
          builder: (_, em, __) => PaddedRow(
            padding: 10,
            children: [
              Flexible(
                child: ElevatedButton(
                  onPressed: () => em.selectCaptureRootFolder(),
                  child: Text(em.captureRootFolder),
                ),
              ),
              IconButton(
                onPressed: () => OpenFilex.open(em.captureRootFolder),
                icon: const Icon(Icons.folder_copy),
                iconSize: 40,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

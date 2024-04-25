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
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Saved captures to"),
                  Text(
                    "This folder is used to temporarily store screenshots during animation"
                    " which can be later exported into gif or video format."
                    " Please clean up this when you are done.",
                    style:
                        Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Flexible(
              child: Consumer<ExportsModel>(
                builder: (_, em, __) => PaddedRow(
                  padding: 10,
                  children: [
                    IconButton(
                      onPressed: () => OpenFilex.open(em.captureRootFolder),
                      icon: const Icon(Icons.folder_copy),
                      iconSize: 40,
                    ),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () => em.selectCaptureRootFolder(),
                        child: Text(em.captureRootFolder),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

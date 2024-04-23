import 'package:anki_progress/view_models/exports_model.dart';
import 'package:anki_progress/views/basic/padded_column.dart';
import 'package:anki_progress/views/basic/padded_row.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';

class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PaddedColumn(
      padding: 20,
      children: [
        Text(
          "Export options:",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        PaddedRow(
          padding: 10,
          children: const [
            ElevatedButton(
              onPressed: null,
              child: Text("Video"),
            ),
            Text("Coming soon"),
          ],
        ),
        Consumer<ExportsModel>(builder: (_, em, __) {
          return PaddedRow(
            padding: 10,
            children: [
              ElevatedButton(
                onPressed: () => em.exportGIF(),
                child: FutureBuilder(
                  future: em.exportGIFState,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Error occurred. Please try again");
                    } else {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const Text("Exporting to .gif");
                        case ConnectionState.done:
                          return Text(".gif exported to ${em.videosFolder}");
                        default:
                          return const Text(".gif");
                      }
                    }
                  },
                ),
              ),
              IconButton(
                onPressed: () => OpenFilex.open(em.videosFolder),
                icon: const Icon(Icons.folder_copy),
              ),
            ],
          );
        }),
      ],
    );
  }
}

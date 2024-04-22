import 'package:anki_progress/view_models/exports_model.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';

class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: null,
          child: Text("Export to video"),
        ),
        Consumer<ExportsModel>(builder: (_, em, __) {
          return ElevatedButton(
            onPressed: () => em.exportGIF(),
            child: FutureBuilder<bool>(
              future: em.exportGIFState,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Error occurred. Please try again");
                } else {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Text("Exporting to GIF");
                    case ConnectionState.done:
                      return Row(
                        children: [
                          Text("GIF exported to ${em.exportsFolder}"),
                          IconButton(
                            onPressed: () => OpenFilex.open(em.exportsFolder),
                            icon: Icon(Icons.open_in_browser),
                          ),
                        ],
                      );
                    default:
                      return const Text("Export to GIF");
                  }
                }
              },
            ),
          );
        }),
      ],
    );
  }
}

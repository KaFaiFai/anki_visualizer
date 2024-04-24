import 'package:anki_progress/services/internet/ffmpeg_installer.dart';
import 'package:anki_progress/view_models/exports_model.dart';
import 'package:anki_progress/views/basic/padded_column.dart';
import 'package:anki_progress/views/basic/padded_row.dart';
import 'package:anki_progress/views/basic/text_divider.dart';
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
        Consumer<ExportsModel>(
          builder: (_, em, __) {
            final text = switch (em.ffmpegInstallerState) {
              FFmpegInstallerState.none => em.isFFmpegAvailable ? "Reinstall FFmpeg" : "Install FFmpeg",
              FFmpegInstallerState.downloading => "Downloading FFmpeg. This may take a while ...",
              FFmpegInstallerState.unzipping => "Unzipping FFmpeg",
              FFmpegInstallerState.completed => "FFmpeg installed",
              FFmpegInstallerState.error => "Error has occurred. Please retry",
            };
            return ElevatedButton(
              onPressed: em.installFFmpeg,
              child: Text(text),
            );
          },
        ),
        const TextDivider("Export options", space: 40),
        Consumer<ExportsModel>(
          builder: (_, em, __) => ElevatedButton(
            onPressed: em.isFFmpegAvailable ? em.exportVideo : null,
            child: FutureBuilder(
              future: em.exportVideoResult,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text("Error occurred. Please try again");
                } else {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Text("Exporting to .mp4");
                    case ConnectionState.done:
                      return Text(".mp4 exported to ${em.videosFolder}");
                    default:
                      return const Text(".mp4");
                  }
                }
              },
            ),
          ),
        ),
        Consumer<ExportsModel>(
          builder: (_, em, __) => PaddedRow(
            padding: 10,
            children: [
              ElevatedButton(
                onPressed: em.isFFmpegAvailable ? em.exportGIF : null,
                child: FutureBuilder(
                  future: em.exportGIFResult,
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
          ),
        ),
      ],
    );
  }
}

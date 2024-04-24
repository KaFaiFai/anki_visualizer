import 'package:anki_progress/models/export_format.dart';
import 'package:anki_progress/services/internet/ffmpeg_installer.dart';
import 'package:anki_progress/view_models/exports_model.dart';
import 'package:anki_progress/views/basic/padded_column.dart';
import 'package:anki_progress/views/basic/padded_row.dart';
import 'package:anki_progress/views/basic/text_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  Widget buildFFmpegInstallField(BuildContext context) {
    return Consumer<ExportsModel>(
      builder: (_, em, __) {
        final List<Widget> indicator = switch (em.ffmpegInstallerState) {
          FFmpegInstallerState.none => [],
          FFmpegInstallerState.downloading => const [
              SizedBox(width: 300, child: AspectRatio(aspectRatio: 1, child: CircularProgressIndicator())),
              Text("Downloading FFmpeg. This may take several minutes ..."),
            ],
          FFmpegInstallerState.unzipping => const [
              SizedBox(width: 300, child: AspectRatio(aspectRatio: 1, child: CircularProgressIndicator())),
              Text("Unzipping FFmpeg"),
            ],
          FFmpegInstallerState.completed => [
              Text("FFmpeg installed successfully!", style: Theme.of(context).textTheme.titleSmall),
            ],
          FFmpegInstallerState.error => [
              Text(
                "Error has occurred. Please retry",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ],
        };
        return PaddedColumn(
          padding: 20,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: MarkdownBody(
                    data: "This program uses **FFmpeg** to convert the captured images"
                        " into animations in the form of video or gif."
                        " Read more about it here: https://ffmpeg.org/",
                    onTapLink: (_, url, __) {
                      if (url != null) launchUrl(Uri.parse(url));
                    },
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: em.installFFmpeg,
                  child: PaddedRow(
                    padding: 10,
                    children: [
                      const Icon(Icons.download),
                      Text(em.isFFmpegAvailable ? "Reinstall FFmpeg" : "Install FFmpeg"),
                    ],
                  ),
                ),
              ],
            ),
            ...indicator,
          ],
        );
      },
    );
  }

  Widget buildExportFields(BuildContext context) {
    return Consumer<ExportsModel>(builder: (_, em, __) {
      return PaddedColumn(
        padding: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Output format"),
              DropdownButton<ExportFormat>(
                value: em.format,
                onChanged: em.updateExportFormat,
                items: ExportFormat.values
                    .map(
                      (e) => DropdownMenuItem<ExportFormat>(
                        value: e,
                        child: Text(
                          e.name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          SizedBox(
            width: 300,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(textStyle: Theme.of(context).textTheme.displayLarge),
              onPressed: em.isFFmpegAvailable ? em.export : null,
              child: const Text("Export"),
            ),
          ),
          FutureBuilder(
            future: em.exportResult,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Exporting ${em.format.name} to ${em.videosFolder}");
              } else if (snapshot.hasError) {
                return Text(
                  "Error occurred. Please try again",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),
                );
              } else if (!snapshot.hasData) {
                return Container();
              }
              final code = snapshot.requireData.exitCode;
              if (code == 0) {
                return Text(
                  "File exported successfully!",
                  style: Theme.of(context).textTheme.titleSmall,
                );
              }
              return Container();
            },
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: PaddedColumn(
          padding: 20,
          children: [
            buildFFmpegInstallField(context),
            const TextDivider("Export options", space: 40),
            buildExportFields(context),
          ],
        ),
      ),
    );
  }
}

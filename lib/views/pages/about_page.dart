import 'package:anki_progress/core/values.dart';
import 'package:anki_progress/views/basic/padded_column.dart';
import 'package:anki_progress/views/components/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 1000,
          child: PaddedColumn(
            padding: 20,
            children: [
              SizedBox(height: 100, child: AppButton()),
              MarkdownBody(
                data: "Anki Visualize is an open source program for visualizing the learning progress of using Anki."
                    " You may view the source code here: https://github.com/KaFaiFai/anki_visualizer",
                onTapLink: (_, url, __) {
                  if (url != null) launchUrl(Uri.parse(url));
                },
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Developed by"), Text("Rapid Rabbit")],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Support us"), Text("Buy me a coffee")],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [const Text("Version"), Text(Values.version)],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

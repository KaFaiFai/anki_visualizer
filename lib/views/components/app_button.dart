import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../basic/padded_row.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelMedium,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      onPressed: () => launchUrl(Uri.parse("https://github.com/KaFaiFai/anki_visualizer")),
      child: PaddedRow(
        padding: 10,
        children: [
          const Text("Anki Visualize"),
          Image.asset("assets/images/icon.png"),
        ],
      ),
    );
  }
}

import 'package:anki_visualizer/core/values.dart';
import 'package:flutter/material.dart';

import '../basic/padded_row.dart';

class AppButton extends StatelessWidget {
  final void Function()? onPress;

  const AppButton({super.key, this.onPress});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelMedium,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        disabledForegroundColor: Theme.of(context).colorScheme.onBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      onPressed: onPress,
      child: PaddedRow(
        padding: 10,
        children: [
          const Text(Values.appName),
          Image.asset("assets/images/icon-no_bg.png"),
        ],
      ),
    );
  }
}

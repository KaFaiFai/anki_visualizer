import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  final String text;
  final double? height;
  final Color? color;
  final double space;

  const TextDivider(this.text, {super.key, this.height, this.color, this.space = 0});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Divider(height: height, color: color)),
        SizedBox(width: space),
        Text(text),
        SizedBox(width: space),
        Expanded(child: Divider(height: height, color: color)),
      ],
    );
  }
}

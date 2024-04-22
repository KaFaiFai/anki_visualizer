import 'package:flutter/material.dart';

class PaddedRow extends StatelessWidget {
  final double padding;
  final Color paddingColor;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final List<Widget> children;

  PaddedRow({
    super.key,
    required this.padding,
    this.paddingColor = Colors.transparent,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    required this.children,
  }) {
    assert([MainAxisAlignment.start, MainAxisAlignment.center, MainAxisAlignment.end].contains(mainAxisAlignment));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];
    for (int i = 0; i < children.length; i++) {
      widgets.add(children[i]);
      if ((i < children.length - 1) && (padding > 0)) {
        widgets.add(Container(width: padding, color: paddingColor));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: widgets,
    );
  }
}

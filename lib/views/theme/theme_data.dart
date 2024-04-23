import 'package:anki_progress/views/theme/text_theme.dart';
import 'package:flutter/material.dart';

import 'color_schemes.g.dart';

final elevatedButtonTheme = ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    foregroundColor: lightColorScheme.background,
    backgroundColor: lightColorScheme.primary,
    textStyle: textTheme.bodyMedium,
    padding: const EdgeInsets.all(20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  ),
);

final outlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    textStyle: textTheme.bodyMedium,
    padding: const EdgeInsets.all(20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    side: const BorderSide(width: 2),
  ),
);

final themeData = ThemeData(
  colorScheme: lightColorScheme,
  textTheme: textTheme,
  useMaterial3: true,
  elevatedButtonTheme: elevatedButtonTheme,
  outlinedButtonTheme: outlinedButtonTheme,
);

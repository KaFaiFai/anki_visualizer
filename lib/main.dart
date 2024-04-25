import 'package:anki_progress/controller/routes.dart';
import 'package:anki_progress/controller/setup_other.dart'
    if (dart.library.html) 'package:anki_progress/controller/setup_web.dart'
    if (dart.library.io) 'package:anki_progress/controller/setup_other.dart'
    as setup; // so that other platforms won't load web specific plugins
import 'package:anki_progress/view_models/data_source_model.dart';
import 'package:anki_progress/view_models/exports_model.dart';
import 'package:anki_progress/view_models/preference_model.dart';
import 'package:anki_progress/views/components/app_button.dart';
import 'package:anki_progress/views/pages/cards_page.dart';
import 'package:anki_progress/views/pages/configuration_page.dart';
import 'package:anki_progress/views/pages/export_page.dart';
import 'package:anki_progress/views/pages/file_page.dart';
import 'package:anki_progress/views/run_with_app_container.dart';
import 'package:anki_progress/views/theme/theme_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  setup.setup();
  runWithAppContainer(const AnkiVisualizer(), includeMaterialApp: false);
}

class AnkiVisualizer extends StatelessWidget {
  const AnkiVisualizer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DataSourceModel()),
        ChangeNotifierProvider(create: (context) => PreferenceModel()),
        ChangeNotifierProvider(create: (context) => ExportsModel()),
      ],
      child: MaterialApp(
        title: "Anki Progress",
        theme: themeData,
        showPerformanceOverlay: kProfileMode,
        // debugShowCheckedModeBanner: false,
        initialRoute: Routes.filePage,
        navigatorObservers: [Routes.buildPageObserver()],
        onGenerateRoute: (settings) {
          final Widget? body = switch (settings.name) {
            Routes.filePage => const FilePage(),
            Routes.configurationPage => const ConfigurationPage(),
            Routes.cardsPage => const CardsPage(),
            Routes.exportPage => const ExportPage(),
            _ => null,
          };
          if (body != null) {
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => Scaffold(
                backgroundColor: themeData.colorScheme.background,
                appBar: AppBar(actions: const [AppButton()]),
                body: body,
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}

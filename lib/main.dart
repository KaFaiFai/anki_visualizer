import 'package:anki_progress/view_models/view_model.dart';
import 'package:anki_progress/views/pages/file_page.dart';
import 'package:anki_progress/views/run_with_app_container.dart';
import 'package:anki_progress/views/theme/theme_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runWithAppContainer(const AnkiProgress(), includeMaterialApp: false);
}

class AnkiProgress extends StatelessWidget {
  const AnkiProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ViewModel(),
      child: MaterialApp(
        title: "Anki Progress",
        theme: themeData,
        showPerformanceOverlay: kProfileMode,
        // debugShowCheckedModeBanner: false,
        initialRoute: Routes.filePage,
        navigatorObservers: [Routes.buildPageObserver()],
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case Routes.filePage:
              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (context, __, ___) => Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  body: const FilePage(),
                ),
                transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
              );
          }
          return null;
        },
      ),
    );
  }
}

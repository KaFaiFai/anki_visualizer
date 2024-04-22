import 'package:anki_progress/controller/setup_other.dart'
    if (dart.library.html) 'package:anki_progress/controller/setup_web.dart'
    if (dart.library.io) 'package:anki_progress/controller/setup_other.dart'
    as setup; // so that other platforms won't load web specific plugins
import 'package:anki_progress/view_models/data_source_model.dart';
import 'package:anki_progress/view_models/exports_model.dart';
import 'package:anki_progress/view_models/preference_model.dart';
import 'package:anki_progress/views/pages/cards_page.dart';
import 'package:anki_progress/views/pages/configuration_page.dart';
import 'package:anki_progress/views/pages/file_page.dart';
import 'package:anki_progress/views/run_with_app_container.dart';
import 'package:anki_progress/views/theme/theme_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  setup.setup();
  runWithAppContainer(const AnkiProgress(), includeMaterialApp: false);
}

class AnkiProgress extends StatelessWidget {
  const AnkiProgress({super.key});

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
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: themeData.colorScheme.background,
            appBar: AppBar(
              title: const TabBar(
                tabs: [Tab(text: "File"), Tab(text: "Config"), Tab(text: "Cards")],
              ),
            ),
            body: const TabBarView(
              children: [FilePage(), ConfigurationPage(), CardsPage()],
            ),
          ),
        ),
      ),
    );
  }
}

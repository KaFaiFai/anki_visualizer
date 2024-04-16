import 'package:anki_progress/view_models/view_model.dart';
import 'package:anki_progress/views/pages/cards_page.dart';
import 'package:anki_progress/views/pages/file_page.dart';
import 'package:anki_progress/views/run_with_app_container.dart';
import 'package:anki_progress/views/theme/theme_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: themeData.colorScheme.background,
            appBar: AppBar(
              bottom: const TabBar(
                tabs: [Tab(text: "File"), Tab(text: "Cards")],
              ),
            ),
            body: const TabBarView(
              children: [FilePage(), CardsPage()],
            ),
          ),
        ),
      ),
    );
  }
}

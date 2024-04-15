import 'package:flutter/material.dart';

/// Include app theme, background color
Future<void> runWithAppContainer(
  Widget widget, {
  String title = "runMyApp",
  bool includeMaterialApp = true,
  Color? backgroundColor,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(AppContainer(
    title: title,
    widget: widget,
    includeMaterialApp: includeMaterialApp,
    backgroundColor: backgroundColor,
  ));
}

class AppContainer extends StatelessWidget {
  final String title;
  final Widget widget;
  final bool includeMaterialApp;
  final Color? backgroundColor;

  const AppContainer({
    super.key,
    required this.title,
    required this.widget,
    required this.includeMaterialApp,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: includeMaterialApp
          ? MaterialApp(
              title: title,
              debugShowCheckedModeBanner: false,
              home: Scaffold(body: widget, backgroundColor: backgroundColor),
            )
          : widget,
    );
  }
}

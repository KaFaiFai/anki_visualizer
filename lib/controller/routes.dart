import 'package:flutter/material.dart';

class Routes {
  Routes._();

  static const filePage = '/'; // to make it the index page
  static const dictionaryPage = '/dictionary';
  static const statisticsPage = '/statistics';
  static const infoPage = '/info';
  static const privacyPolicyPage = '/privacy_policy';
  static const termsPage = '/terms_and_conditions';

  static NavigatorObserver buildPageObserver() {
    return _NavigatorObserver((route) {
      switch (route?.settings.name) {
        case filePage:
        // vm.init();
        default:
          break;
      }
    });
  }
}

class _NavigatorObserver extends NavigatorObserver {
  final void Function(Route<dynamic>?) onEnterNewPage;

  _NavigatorObserver(this.onEnterNewPage);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('didPush was called. ${previousRoute?.settings.name} -> ${route.settings.name} ');
    onEnterNewPage(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('didPop was called. ${previousRoute?.settings.name} <- ${route.settings.name}');
    onEnterNewPage(previousRoute);
  }
}

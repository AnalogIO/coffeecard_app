import 'package:coffeecard/widgets/pages/settings/settings_page.dart';
import 'package:flutter/material.dart';

class SettingsFlow extends StatelessWidget {
  static Route get route => MaterialPageRoute(builder: (_) => SettingsFlow());

  static final navigatorKey = GlobalKey<NavigatorState>();

  static void push(Widget page) {
    navigatorKey.currentState!.push(_route(page));
  }

  static Route _route(Widget page) => MaterialPageRoute(builder: (_) => page);

  Future<bool> _didPopRoute() async => navigatorKey.currentState!.maybePop();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await _didPopRoute(),
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: (_) => _route(const SettingsPage()),
      ),
    );
  }
}

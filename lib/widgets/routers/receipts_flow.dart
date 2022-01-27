import 'package:coffeecard/widgets/pages/receipts/receipts_page.dart';
import 'package:flutter/material.dart';

class ReceiptsFlow extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static Route get route => MaterialPageRoute(builder: (_) => ReceiptsFlow());

  Future<bool> _didPopRoute() async => navigatorKey.currentState!.maybePop();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await _didPopRoute(),
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => ReceiptsPage());
      default:
        throw Exception('(ReceiptsFlow) Unknown route: ${settings.name}');
    }
  }
}

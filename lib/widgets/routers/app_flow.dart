import 'package:flutter/material.dart';

/// Represents a Navigator for a certain flow of the app.
class AppFlow extends StatefulWidget {
  const AppFlow({required this.initialRoute});
  final Route initialRoute;

  @override
  State<AppFlow> createState() => _AppFlowState();
}

class _AppFlowState extends State<AppFlow> {
  final navigatorKey = GlobalKey<NavigatorState>();

  Future<bool> _didPopRoute() async {
    return navigatorKey.currentState!.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await _didPopRoute(),
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: (_) => widget.initialRoute,
      ),
    );
  }
}

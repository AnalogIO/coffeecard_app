import 'package:flutter/material.dart';

/// Represents a Navigator for a certain flow of the app.
class AppFlow extends StatefulWidget {
  const AppFlow({required this.initialRoute, this.navigatorKey});
  final Route initialRoute;
  final GlobalKey<NavigatorState>? navigatorKey;

  @override
  State<AppFlow> createState() => _AppFlowState();
}

class _AppFlowState extends State<AppFlow> {
  late GlobalKey<NavigatorState> navigatorKey;

  @override
  void initState() {
    super.initState();
    navigatorKey = widget.navigatorKey ?? GlobalKey<NavigatorState>();
  }

  Future<bool> _didPopRoute() {
    return navigatorKey.currentState!.maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (a, b) async => !await _didPopRoute(),
      child: Navigator(
        key: navigatorKey,
        onGenerateRoute: (_) => widget.initialRoute,
      ),
    );
  }
}

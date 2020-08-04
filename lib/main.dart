import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/theme.dart';
import 'package:coffeecard/service_locator.dart';
// import 'package:coffeecard/widgets/pages/home_page.dart';
import 'package:coffeecard/widgets/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  configureServices();
  runApp(App());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appTitle,
      theme: analogTheme,
      home: LoginPage(),
    );
  }
}

class App extends StatelessWidget {
  const App({
    Key key,
  })  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppView();
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
        title: Strings.appTitle,
        theme: analogTheme,
        home: LoginPage()
    );
  }
}
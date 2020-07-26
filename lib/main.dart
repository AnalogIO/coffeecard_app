import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/theme.dart';
import 'package:coffeecard/service_locator.dart';
// import 'package:coffeecard/widgets/pages/home_page.dart';
import 'package:coffeecard/widgets/pages/login_page.dart';
import 'package:flutter/material.dart';


void main() {
  configureServices();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appTitle,
      theme: analogTheme,
      // home: HomePage(),
      home: LoginPage(),
    );
  }
}

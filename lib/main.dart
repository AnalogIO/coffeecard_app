import 'package:flutter/material.dart';

import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/theme.dart';

import 'package:coffeecard/widgets/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appTitle,
      theme: analogTheme,
      home: HomePage(),
    );
  }
}

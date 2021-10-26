import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  static Route get route =>
      MaterialPageRoute<void>(builder: (_) => SplashPage());

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

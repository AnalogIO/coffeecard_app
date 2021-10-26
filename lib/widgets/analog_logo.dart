import 'package:flutter/material.dart';

class AnalogLogo extends StatelessWidget {
  final double height;
  const AnalogLogo() : height = 78;
  const AnalogLogo.small() : height = 52;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, child: Image.asset('assets/logo.png'));
  }
}

class AnalogRecieptLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 26, child: Image.asset('assets/logo-dark.png'));
  }
}

import 'package:coffeecard/utils/responsive.dart';
import 'package:flutter/material.dart';

class AnalogLogo extends StatelessWidget {
  const AnalogLogo();

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'ANALOG_LOGO',
      child: SizedBox(
        height: deviceIsSmall(context) ? 52 : 78,
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}

class AnalogRecieptLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 26, child: Image.asset('assets/logo-dark.png'));
  }
}

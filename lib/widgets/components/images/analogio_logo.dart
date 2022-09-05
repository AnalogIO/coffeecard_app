import 'package:coffeecard/utils/responsive.dart';
import 'package:flutter/material.dart';

class AnalogIOLogo extends StatelessWidget {
  const AnalogIOLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: deviceIsSmall(context) ? 86 : 100,
      child: Image.asset('assets/analogio_logo.png'),
    );
  }
}

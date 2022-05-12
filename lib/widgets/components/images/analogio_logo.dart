import 'package:coffeecard/utils/responsive.dart';
import 'package:flutter/material.dart';

class AnalogIOLogo extends StatelessWidget {
  const AnalogIOLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: deviceIsSmall(context) ? 52 : 78,
      child: Image.asset('assets/analogio_logo.png'),
    );
  }
}

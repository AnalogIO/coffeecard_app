import 'package:flutter/material.dart';

class AnalogIOLogo extends StatelessWidget {
  const AnalogIOLogo.small() : width = 120;
  const AnalogIOLogo.large() : width = 180;

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Image.asset('assets/analogio_logo.png'),
    );
  }
}

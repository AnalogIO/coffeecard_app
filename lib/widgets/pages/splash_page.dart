import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/widgets/analog_logo.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColor.primary,
      body: Center(child: AnalogLogo()),
    );
  }
}

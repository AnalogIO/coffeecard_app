import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/widgets/components/images/analog_logo.dart';
import 'package:flutter/material.dart';

class SplashLoadingPage extends StatelessWidget {
  const SplashLoadingPage();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColor.primary,
      child: Center(child: AnalogLogo()),
    );
  }
}

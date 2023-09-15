import 'package:coffeecard/base/style/app_colors.dart';
import 'package:coffeecard/core/widgets/images/analog_logo.dart';
import 'package:flutter/material.dart';

class SplashLoadingPage extends StatelessWidget {
  const SplashLoadingPage();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.primary,
      child: Center(child: AnalogLogo()),
    );
  }
}

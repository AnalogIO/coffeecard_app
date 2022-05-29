import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/widgets/components/images/analog_logo.dart';
import 'package:flutter/material.dart';

class SplashLoadingPage extends StatelessWidget {
  const SplashLoadingPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.primary,
      child: const Center(child: AnalogLogo()),
    );
  }
}

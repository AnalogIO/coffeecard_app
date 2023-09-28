import 'dart:async';

import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/widgets/images/analog_logo.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SplashLoadingPage extends StatefulWidget {
  const SplashLoadingPage();

  @override
  State<SplashLoadingPage> createState() => _SplashLoadingPageState();
}

class _SplashLoadingPageState extends State<SplashLoadingPage> {
  Timer? countdownTimer;
  bool show = false;
  final timeBeforeShowLoadingIndicator = const Duration(seconds: 3);

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(timeBeforeShowLoadingIndicator, (_) => stopTimer());
  }

  void stopTimer() {
    setState(() {
      countdownTimer!.cancel();
      show = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AnalogLogo(),
          const Gap(32),
          CircularProgressIndicator(
            color: show ? AppColors.white : AppColors.primary,
          ),
        ],
      ),
    );
  }
}

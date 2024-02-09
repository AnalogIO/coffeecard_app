import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/features/environment.dart';
import 'package:flutter/material.dart';

class TestingEnvironmentBanner extends StatelessWidget {
  const TestingEnvironmentBanner();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.primary,
      child: Center(child: TestingEnvironmentButton()),
    );
  }
}

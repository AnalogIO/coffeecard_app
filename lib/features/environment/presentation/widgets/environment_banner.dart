import 'package:coffeecard/base/style/app_colors.dart';
import 'package:coffeecard/features/environment/presentation/widgets/environment_button.dart';
import 'package:flutter/material.dart';

class EnvironmentBanner extends StatelessWidget {
  const EnvironmentBanner();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.primary,
      child: Center(child: EnvironmentButton()),
    );
  }
}

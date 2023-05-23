import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/features/environment/presentation/widgets/environment_button.dart';
import 'package:flutter/material.dart';

class EnvironmentBanner extends StatelessWidget {
  const EnvironmentBanner();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColor.primary,
      child: Center(child: EnvironmentButton()),
    );
  }
}

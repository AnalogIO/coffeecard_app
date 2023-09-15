import 'package:coffeecard/base/style/app_colors.dart';
import 'package:flutter/material.dart';

class PasscodeDot extends StatelessWidget {
  final bool isLit;
  final bool isError;
  const PasscodeDot({
    required this.isLit,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    final Color fill = isError ? AppColors.errorOnDark : AppColors.white;
    final double opacity = isLit || isError ? 1 : 0.35;

    return AnimatedContainer(
      width: 20,
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 15),
      decoration: BoxDecoration(
        color: fill.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
    );
  }
}

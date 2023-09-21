import 'package:coffeecard/base/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBuilder extends StatelessWidget {
  final bool showShimmer;
  final Widget Function(BuildContext, Color) builder;

  const ShimmerBuilder({required this.showShimmer, required this.builder});

  Color get _colorIfShimmer =>
      showShimmer ? AppColors.shimmerBackground : Colors.transparent;

  @override
  Widget build(BuildContext context) {
    final child = builder(context, _colorIfShimmer);
    if (!showShimmer) return child;
    return Shimmer(
      gradient: AppColors.shimmerGradient,
      child: child,
    );
  }
}

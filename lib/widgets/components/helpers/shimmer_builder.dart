import 'package:coffeecard/base/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBuilder extends StatelessWidget {
  final bool showShimmer;
  final Widget Function(BuildContext, Color) builder;

  const ShimmerBuilder({required this.showShimmer, required this.builder});

  Color get _colorIfShimmer => showShimmer ? Colors.black : Colors.transparent;

  @override
  Widget build(BuildContext context) {
    final child = builder(context, _colorIfShimmer);
    if (!showShimmer) return child;
    return Shimmer(
      gradient: AppColor.shimmerGradient,
      child: child,
    );
  }
}

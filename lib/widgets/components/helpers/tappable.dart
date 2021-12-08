import 'package:coffeecard/base/style/colors.dart';
import 'package:flutter/material.dart';

class Tappable extends StatelessWidget {
  final Color color;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final GestureTapCallback onTap;
  final Widget child;
  const Tappable({
    this.color = Colors.transparent,
    this.padding,
    this.borderRadius,
    this.border,
    this.boxShadow,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final bool lightSplash =
        color == AppColor.white || color == AppColor.primary;
    return Container(
      decoration: BoxDecoration(
        boxShadow: boxShadow,
        borderRadius: borderRadius,
        border: border,
      ),
      child: Material(
        color: color,
        borderRadius: borderRadius,
        child: InkWell(
          highlightColor:
              lightSplash ? null : AppColor.primary.withOpacity(0.12),
          splashColor: lightSplash ? null : AppColor.primary.withOpacity(0.12),
          onTap: onTap,
          borderRadius: borderRadius,
          child: Container(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}

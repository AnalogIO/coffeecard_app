import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

class Tappable extends StatelessWidget {
  final Color? color;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final Color? borderColor;
  final double elevation;
  final GestureTapCallback? onTap;
  final Widget child;
  const Tappable({
    this.color = Colors.transparent,
    this.padding = EdgeInsets.zero,
    this.borderRadius = BorderRadius.zero,
    this.borderColor = Colors.transparent,
    this.elevation = 0,
    required this.onTap,
    required this.child,
  });

  Color? get splashColor =>
      (color == AppColors.white || color == AppColors.primary)
          ? null
          : AppColors.primary.withOpacity(0.12);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: BorderSide(
          color: borderColor ?? Colors.transparent,
          width: 4,
        ),
      ),
      child: InkWell(
        highlightColor: splashColor,
        splashColor: splashColor,
        onTap: onTap,
        borderRadius: borderRadius,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

/// Decides whether the translucent "Liquid Glass" treatment is used.
///
/// Glass is an iOS idiom: on Android the same shapes are rendered as solid
/// tonal Material surfaces. On iOS it falls back to solid surfaces when the
/// user has asked for increased contrast.
abstract final class AnalogGlass {
  static bool isEnabled(BuildContext context) {
    final platform = Theme.of(context).platform;
    final isApple =
        platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;
    return isApple && !MediaQuery.highContrastOf(context);
  }
}

/// A navigation-layer surface: tab bars, floating buttons, segmented
/// controls and sheets. Keep reading surfaces (tickets, receipts, lists)
/// opaque; glass is for the controls that float above them.
///
/// This is a Flutter approximation of Apple's Liquid Glass (blur, saturation
/// boost, specular rim), not the native renderer.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    super.key,
    required this.child,
    this.dark = false,
    this.radius = 28,
    this.padding = EdgeInsets.zero,
    this.elevated = true,
  });

  final Widget child;

  /// Use the variant for dark backgrounds (sign-in, passcode).
  final bool dark;
  final double radius;
  final EdgeInsetsGeometry padding;

  /// Whether to draw the soft drop shadow that lifts the surface.
  final bool elevated;

  static const _blurSigma = 22.0;

  // Saturation boost so content behind the glass keeps its colour.
  static const _saturate = ColorFilter.matrix(<double>[
    1.5, -0.4, -0.1, 0, 0, //
    -0.1, 1.2, -0.1, 0, 0, //
    -0.1, -0.4, 1.5, 0, 0, //
    0, 0, 0, 1, 0, //
  ]);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    final glass = AnalogGlass.isEnabled(context);

    if (!glass) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: dark ? const Color(0xff3A2A1E) : AppColors.navSurface,
          borderRadius: borderRadius,
        ),
        child: Padding(padding: padding, child: child),
      );
    }

    final tint = dark
        ? AppColors.cream.withValues(alpha: .10)
        : const Color(0xffFCFAF6).withValues(alpha: .52);
    final rim = Colors.white.withValues(alpha: dark ? .18 : .75);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: (dark ? Colors.black : AppColors.espresso)
                      .withValues(alpha: dark ? .30 : .16),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.compose(
            outer: ImageFilter.blur(sigmaX: _blurSigma, sigmaY: _blurSigma),
            inner: _saturate,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(color: rim),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, .45, 1],
                colors: [
                  Color.alphaBlend(
                    Colors.white.withValues(alpha: dark ? .08 : .22),
                    tint,
                  ),
                  tint,
                  tint,
                ],
              ),
            ),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}

/// The dark sign-in backdrop: plain roasted espresso, so the logo and the
/// form are the only things on screen.
class CoffeeBackdrop extends StatelessWidget {
  const CoffeeBackdrop({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      ColoredBox(color: AppColors.roast, child: child);
}

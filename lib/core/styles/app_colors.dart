import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xff362619);
  static const secondary = Color(0xff785B38);
  static const background = Color(0xffE5E2D7);
  static const ticket = Color(0xffD9CB9D);

  static const white = Color(0xffFAFAFA);
  static const gray = Color(0xff767676);
  static const lightGray = Color(0xffC2C2C2);

  static const slightlyHighlighted = Color(0xffFEF4D2);
  static const success = Color(0xff006F02);
  static const errorOnDark = Color(0xffFF7215);
  static const errorOnBright = Color(0xffA80000);
  static const testEnvironmentReceipt = errorOnBright;

  /// Modal backdrop
  static const scrim = Color(0xcc000000);

  // Leaderboard rank medals
  static const goldMedal = Color(0xffFFD91D);
  static const goldMedalBorder = Color(0xffB3980E);
  static const silverMedal = Color(0xffC2C2C2);
  static const silverMedalBorder = Color(0xff767676);
  static const bronzeMedal = Color(0xffD9A169);
  static const bronzeMedalBorder = Color(0xff7A4C1F);

  // Shimmer colors
  static const shimmerBackground = Color(0xFFE0E0E0);
  static const shimmerHighlight = Color(0xFFBDBDBD);
  static const shimmerGradient = LinearGradient(
    colors: [
      shimmerBackground,
      shimmerBackground,
      shimmerHighlight,
      shimmerBackground,
      shimmerBackground,
    ],
  );

  /// Creates a swatch from a given Color.
  //  https://medium.com/@filipvk/creating-a-custom-color-swatch-in-flutter-554bcdcb27f3
  static MaterialColor createMaterialColor(Color color) {
    final strengths = <double>[.05];
    final swatch = <int, Color>{};
    final r = color.r;
    final g = color.g;
    final b = color.b;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (final strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        (r + ((ds < 0 ? r : (255 - r)) * ds)).round(),
        (g + ((ds < 0 ? g : (255 - g)) * ds)).round(),
        (b + ((ds < 0 ? b : (255 - b)) * ds)).round(),
        1,
      );
    }
    return MaterialColor(color.toARGB32(), swatch);
  }
}

import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand palette, aligned with cafeanalog.dk (espresso on cream).
  static const espresso = Color(0xff362619);
  static const roast = Color(0xff2A1D13);
  static const caramel = Color(0xffD9B98A);
  static const crema = Color(0xffF1E8DA);
  static const cream = Color(0xffF9F8F2);
  static const paper = Color(0xffFFFFFF);
  static const grounds = Color(0xff6B5A4A);
  static const groundsDark = Color(0xff4A3626);
  static const open = Color(0xff2F6B4F);

  /// Hairline borders on cards and grouped lists.
  static const border = Color(0xffECE5D8);
  static const divider = Color(0xffF1ECE2);

  /// Solid surfaces used where glass is unavailable (Android, Reduce
  /// Transparency / increased contrast on iOS).
  static const tonal = Color(0xffEFE4D3);
  static const navSurface = Color(0xffF1EAE0);
  static const navIndicator = Color(0xffDCC7A8);

  // Semantic aliases kept for existing widgets.
  static const primary = espresso;
  static const secondary = grounds;
  static const background = cream;
  static const ticket = caramel;

  static const white = Color(0xffFAFAFA);
  static const gray = Color(0xff767676);
  static const lightGray = Color(0xffC2C2C2);

  static const slightlyHighlighted = Color(0xffFEF8EA);
  static const success = Color(0xff006F02);
  static const errorOnDark = Color(0xffFF7215);
  static const errorOnBright = Color(0xffA8321E);
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

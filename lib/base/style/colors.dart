import 'package:flutter/material.dart';

abstract class AppColor {
  static const Color primary = Color(0xff362619);
  static const Color secondary = Color(0xff785B38);
  static const Color background = Color(0xffE5E2D7);
  static const Color ticket = Color(0xffD9CB9D);

  static const Color white = Color(0xffFAFAFA);
  static const Color gray = Color(0xff767676);
  static const Color lightGray = Color(0xffC2C2C2);

  static const Color highlight = Color(0xffFF9500);
  static const Color slightlyHighlighted = Color(0xffFEF4D2);
  static const Color success = Color(0xff4CAF50);
  static const Color error = Color(0xffFF4D00);


  /// Creates a swatch from a given Color.
  //  https://medium.com/@filipvk/creating-a-custom-color-swatch-in-flutter-554bcdcb27f3
  static MaterialColor createMaterialColor(Color color) {
    final strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (final strength in strengths)
      {
        final double ds = 0.5 - strength;
        swatch[(strength * 1000).round()] = Color.fromRGBO(
          r + ((ds < 0 ? r : (255 - r)) * ds).round(),
          g + ((ds < 0 ? g : (255 - g)) * ds).round(),
          b + ((ds < 0 ? b : (255 - b)) * ds).round(),
          1,
        );
      }
    return MaterialColor(color.value, swatch);
  }
}

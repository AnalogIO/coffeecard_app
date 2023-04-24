import 'package:coffeecard/base/style/colors.dart';
import 'package:flutter/material.dart';

final ThemeData analogTheme = ThemeData(
  appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
  primaryColor: AppColor.primary,
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryTextTheme:
      const TextTheme(titleLarge: TextStyle(color: AppColor.white)),
  primaryIconTheme: const IconThemeData(color: AppColor.primary),
  canvasColor: AppColor.background,
  textSelectionTheme:
      const TextSelectionThemeData(cursorColor: AppColor.secondary),
  disabledColor: AppColor.lightGray,
  pageTransitionsTheme: const PageTransitionsTheme(
    // No intent of supporting aditional platforms
    // ignore: avoid-missing-enum-constant-in-map
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: AppColor.createMaterialColor(AppColor.primary),
  ).copyWith(background: AppColor.background),
);

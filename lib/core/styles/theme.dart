import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

final ThemeData analogTheme = ThemeData(
  appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
  primaryColor: AppColors.primary,
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryTextTheme:
      const TextTheme(titleLarge: TextStyle(color: AppColors.white)),
  primaryIconTheme: const IconThemeData(color: AppColors.primary),
  canvasColor: AppColors.background,
  textSelectionTheme:
      const TextSelectionThemeData(cursorColor: AppColors.secondary),
  disabledColor: AppColors.lightGray,
  pageTransitionsTheme: const PageTransitionsTheme(
    // No intent of supporting aditional platforms
    // ignore: avoid-missing-enum-constant-in-map
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: AppColors.createMaterialColor(AppColors.primary),
  ).copyWith(surface: AppColors.background),
);

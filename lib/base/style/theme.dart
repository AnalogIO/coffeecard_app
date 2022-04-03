import 'package:coffeecard/base/style/colors.dart';
import 'package:flutter/material.dart';

final ThemeData analogTheme = ThemeData(
  appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
  primarySwatch: AppColor.createMaterialColor(AppColor.primary),
  primaryColor: AppColor.primary,
  brightness: Brightness.light,
  backgroundColor: AppColor.background,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryTextTheme:
      const TextTheme(headline6: TextStyle(color: AppColor.white)),
  primaryIconTheme: const IconThemeData(color: AppColor.primary),
  canvasColor: AppColor.background,
  textSelectionTheme:
      const TextSelectionThemeData(cursorColor: AppColor.secondary),
  buttonTheme: const ButtonThemeData(
    disabledColor: AppColor.error,
    focusColor: AppColor.error,
  ),
  disabledColor: AppColor.lightGray,
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
);

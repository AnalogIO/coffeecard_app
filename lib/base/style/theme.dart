import 'package:coffeecard/base/style/colors.dart';
import 'package:flutter/material.dart';

final ThemeData analogTheme = ThemeData(
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
  disabledColor: AppColor.lightGray,
);

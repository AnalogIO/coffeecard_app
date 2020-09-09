import 'package:flutter/material.dart';
import 'package:coffeecard/base/style/colors.dart';

final ThemeData analogTheme = ThemeData(
  primarySwatch: AppColor.createMaterialColor(AppColor.primary),
  primaryColor: AppColor.primary,
  brightness: Brightness.light,
  cursorColor: AppColor.secondary,
  backgroundColor: AppColor.background,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryTextTheme: const TextTheme(headline6: TextStyle(color: AppColor.white)),
  primaryIconTheme: const IconThemeData(color: AppColor.primary),
  canvasColor: AppColor.background,
);



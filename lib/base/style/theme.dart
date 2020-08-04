import 'package:flutter/material.dart';
import 'package:coffeecard/base/style/colors.dart';

final ThemeData analogTheme = ThemeData(
  primarySwatch: AppColor.createMaterialColor(AppColor.primary),
  primaryColor: AppColor.primary,
  brightness: Brightness.light,
  cursorColor: AppColor.secondary,
  backgroundColor: AppColor.background,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryTextTheme: TextTheme(title: TextStyle(color: AppColor.white)),
  primaryIconTheme: IconThemeData(color: AppColor.background),
  canvasColor: AppColor.background,
);



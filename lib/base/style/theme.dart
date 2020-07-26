import 'package:flutter/material.dart';
import 'package:coffeecard/base/style/colors.dart';

final analogTheme = ThemeData(
  primarySwatch: AppColor.createMaterialColor(AppColor.primary),
  primaryColor: AppColor.primary,
  brightness: Brightness.light,
  cursorColor: AppColor.secondary,
  backgroundColor: AppColor.background,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

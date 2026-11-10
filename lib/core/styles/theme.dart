import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:flutter/material.dart';

final _colorScheme = ColorScheme.fromSeed(
  seedColor: AppColors.espresso,
).copyWith(
  primary: AppColors.espresso,
  onPrimary: AppColors.cream,
  secondary: AppColors.grounds,
  secondaryContainer: AppColors.navIndicator,
  onSecondaryContainer: AppColors.roast,
  surface: AppColors.background,
  onSurface: AppColors.roast,
  onSurfaceVariant: AppColors.groundsDark,
  surfaceContainer: AppColors.navSurface,
  surfaceContainerLow: AppColors.crema,
  surfaceContainerHigh: AppColors.tonal,
  outline: const Color(0xffCFC4B4),
  outlineVariant: AppColors.border,
  error: AppColors.errorOnBright,
);

/// Lexend ships as one variable font, so every Material text style also
/// sets the matching value on the font's weight axis.
TextTheme _withWeightAxis(TextTheme theme) {
  TextStyle? apply(TextStyle? style) {
    if (style == null) return null;
    final weight = (style.fontWeight ?? FontWeight.w400).value.toDouble();
    return style.copyWith(fontVariations: [FontVariation('wght', weight)]);
  }

  return theme.copyWith(
    displayLarge: apply(theme.displayLarge),
    displayMedium: apply(theme.displayMedium),
    displaySmall: apply(theme.displaySmall),
    headlineLarge: apply(theme.headlineLarge),
    headlineMedium: apply(theme.headlineMedium),
    headlineSmall: apply(theme.headlineSmall),
    titleLarge: apply(theme.titleLarge),
    titleMedium: apply(theme.titleMedium),
    titleSmall: apply(theme.titleSmall),
    bodyLarge: apply(theme.bodyLarge),
    bodyMedium: apply(theme.bodyMedium),
    bodySmall: apply(theme.bodySmall),
    labelLarge: apply(theme.labelLarge),
    labelMedium: apply(theme.labelMedium),
    labelSmall: apply(theme.labelSmall),
  );
}

final ThemeData analogTheme = _baseTheme.copyWith(
  textTheme: _withWeightAxis(_baseTheme.textTheme),
);

final ThemeData _baseTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Lexend',
  colorScheme: _colorScheme,
  scaffoldBackgroundColor: AppColors.background,
  splashFactory: NoSplash.splashFactory,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(48, 54),
      elevation: 0,
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.background,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    showDragHandle: true,
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: AppColors.navSurface,
    indicatorColor: AppColors.navIndicator,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    labelTextStyle: WidgetStateProperty.resolveWith(
      (states) => AppTextStyle.ui(
        12,
        weight: states.contains(WidgetState.selected) ? 600 : 500,
      ),
    ),
    iconTheme: WidgetStateProperty.resolveWith(
      (states) => IconThemeData(
        color: states.contains(WidgetState.selected)
            ? AppColors.roast
            : const Color(0xff5E4F43),
      ),
    ),
  ),
  segmentedButtonTheme: SegmentedButtonThemeData(
    style: SegmentedButton.styleFrom(
      selectedBackgroundColor: AppColors.navIndicator,
      selectedForegroundColor: AppColors.roast,
      foregroundColor: AppColors.groundsDark,
      side: const BorderSide(color: Color(0xffCFC4B4)),
    ),
  ),
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
);

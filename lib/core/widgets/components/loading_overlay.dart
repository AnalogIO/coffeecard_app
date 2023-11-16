import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

class LoadingOverlay {
  static Future<T?> show<T>(BuildContext context) => showDialog<T>(
        context: context,
        barrierColor: AppColors.scrim,
        barrierDismissible: false,
        builder: (_) {
          return PopScope(
            // Will prevent Android back button from closing overlay.
            onPopInvoked: (_) async => false,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.white),
            ),
          );
        },
      );

  static void hide<T extends Object?>(BuildContext context) =>
      Navigator.of(context, rootNavigator: true).pop();
}

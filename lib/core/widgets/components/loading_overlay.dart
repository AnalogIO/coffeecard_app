import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

class LoadingOverlay {
  static void show(BuildContext context) {
    final _ = showAdaptiveDialog(
      context: context,
      barrierColor: AppColors.scrim,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) {
        return WillPopScope(
          // Will prevent Android back button from closing overlay.
          onWillPop: () async => false,
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.white),
          ),
        );
      },
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

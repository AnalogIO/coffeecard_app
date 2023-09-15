import 'package:coffeecard/base/style/app_colors.dart';
import 'package:flutter/material.dart';

void showLoadingOverlay(BuildContext context) {
  final _ = showDialog(
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

void hideLoadingOverlay(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}

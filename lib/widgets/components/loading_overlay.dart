import 'package:coffeecard/base/style/colors.dart';
import 'package:flutter/material.dart';

void showLoadingOverlay(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: AppColor.scrim,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (_) {
      return WillPopScope(
        // Will prevent Android back button from closing overlay.
        onWillPop: () async => false,
        child: const Center(
          child: CircularProgressIndicator(color: AppColor.white),
        ),
      );
    },
  );
}

void hideLoadingOverlay(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}

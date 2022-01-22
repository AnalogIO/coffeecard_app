import 'package:coffeecard/base/style/colors.dart';
import 'package:flutter/material.dart';

class LoadingOverlay {
  final BuildContext _context;

  void hide() {
    Navigator.of(_context, rootNavigator: true).pop();
  }

  void show() {
    showDialog(
      context: _context,
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

  LoadingOverlay.__create(this._context);

  factory LoadingOverlay.of(BuildContext context) {
    return LoadingOverlay.__create(context);
  }
}

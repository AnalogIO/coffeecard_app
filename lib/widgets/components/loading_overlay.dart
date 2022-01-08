import 'package:coffeecard/base/style/colors.dart';
import 'package:flutter/material.dart';

class LoadingOverlay {
  BuildContext _context;

  void hide() {
    Navigator.of(_context).pop();
  }

  void show() {
    showDialog(
      context: _context,
      barrierColor: AppColor.scrim,
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

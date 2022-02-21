import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/widgets/components/purchase_process.dart';
import 'package:flutter/material.dart';

class PurchaseOverlay {
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
          onWillPop: () async => true,
          child: PurchaseProcess(),
        );
      },
    );
  }

  PurchaseOverlay.__create(this._context);

  factory PurchaseOverlay.of(BuildContext context) {
    return PurchaseOverlay.__create(context);
  }
}

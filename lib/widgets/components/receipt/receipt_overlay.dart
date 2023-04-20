import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/utils/responsive.dart';
import 'package:coffeecard/widgets/components/receipt/receipt_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:screen_brightness/screen_brightness.dart';

class ReceiptOverlay {
  // TODO(marfavi): see if a more generic version can be made that supports both the loading overlay and this one, https://github.com/AnalogIO/coffeecard_app/issues/386
  BuildContext _context;

  void hide() {
    Navigator.of(_context).pop();
  }

  Future<void> show({
    required Receipt receipt,
    required bool isTestEnvironment,
    String? optionalText,
  }) async {
    await ScreenBrightness().setScreenBrightness(1);
    if (_context.mounted) {
      final _ = await showDialog(
        context: _context,
        barrierColor: AppColor.scrim,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.all(deviceIsSmall(context) ? 24 : 48),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ReceiptCard(
                    productName: receipt.productName,
                    time: receipt.timeUsed,
                    isPurchase:
                        receipt.transactionType == TransactionType.purchase,
                    isInOverlay: true,
                    isTestEnvironment: isTestEnvironment,
                  ),
                  const Gap(12),
                  Text(
                    Strings.receiptTapAnywhereToDismiss,
                    style: AppTextStyle.explainerBright,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    await ScreenBrightness().resetScreenBrightness();
  }

  ReceiptOverlay.__create(this._context);

  factory ReceiptOverlay.of(BuildContext context) {
    return ReceiptOverlay.__create(context);
  }
}

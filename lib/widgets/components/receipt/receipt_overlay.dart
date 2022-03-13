import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/widgets/components/receipt/receipt_card.dart';
import 'package:flutter/material.dart';

class ReceiptOverlay {
  //TODO see if a more generic version can be made that supports both the loading overlay and this one
  BuildContext _context;

  void hide() {
    Navigator.of(_context).pop();
  }

  void show(
    Receipt receipt, {
    required bool isTestEnvironment,
    String? optionalText,
  }) {
    showDialog(
      context: _context,
      barrierColor: AppColor.scrim,
      builder: (_) {
<<<<<<< HEAD
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ReceiptCard(
                productName: receipt.productName,
                time: receipt.timeUsed,
                isPurchase: receipt.transactionType == TransactionType.purchase,
                isInOverlay: true,
                isTestEnvironment: isTestEnvironment,
              ),
              Text(
                Strings.receiptTapAnywhereToDismiss,
                style: AppTextStyle.explainerBright,
              )
            ],
=======
        return Padding(
          padding: const EdgeInsets.all(48),
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
                ),
                Text(
                  Strings.receiptTapAnywhereToDismiss,
                  style: AppTextStyle.explainerBright,
                )
              ],
            ),
>>>>>>> MobilePay spike (#171)
          ),
        );
      },
    );
  }

  ReceiptOverlay.__create(this._context);

  factory ReceiptOverlay.of(BuildContext context) {
    return ReceiptOverlay.__create(context);
  }
}

import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/cubits/purchase/purchase_cubit.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:coffeecard/widgets/components/purchase/purchase_process.dart';
import 'package:coffeecard/widgets/components/receipt/receipt_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseOverlay {
  final BuildContext _context;

  void hide() {
    Navigator.of(_context, rootNavigator: true).pop();
  }

  void show(InternalPaymentType paymentType, int productId) {
    showDialog(
      context: _context,
      barrierColor: AppColor.scrim,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) {
        return WillPopScope(
          // Will prevent Android back button from closing overlay.
          onWillPop: () async => true,
          child: BlocProvider(
            create: (context) =>
                PurchaseCubit(PaymentHandler(paymentType), productId),
            child: BlocListener<PurchaseCubit, PurchaseState>(
              listener: (context, state) {
                if (state is PurchaseCompleted) {
                  hide();
                  final navigator = Navigator.of(context);
                  //TODO consider using popUntil instead of this
                  while (navigator.canPop()) { //Gets the user back to the homescreen of the app
                    navigator.pop();
                  }
                  final payment = state.payment;
                  ReceiptOverlay.of(context).show(
                    Receipt(
                      timeUsed: payment.purchaseTime,
                      amountPurchased: 0, //Not used on the purchase display
                      transactionType: TransactionType.purchase,
                      productName: payment.productName,
                      price: payment.price,
                      id: productId,
                    ),
                  );
                }
              },
              child: PurchaseProcess(),
            ),
          ),
        );
      },
    );
  }

  PurchaseOverlay.__create(this._context);

  factory PurchaseOverlay.of(BuildContext context) {
    return PurchaseOverlay.__create(context);
  }
}

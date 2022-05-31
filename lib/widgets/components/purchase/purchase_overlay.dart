import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/cubits/purchase/purchase_cubit.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:coffeecard/widgets/components/purchase/purchase_process.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<Payment?> showPurchaseOverlay({
  required BuildContext context,
  required Product product,
  required InternalPaymentType paymentType,
}) async =>
    showDialog<Payment>(
      context: context,
      barrierColor: AppColor.scrim,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) {
        return WillPopScope(
          // Will prevent Android back button from closing overlay.
          onWillPop: () async => false,
          child: BlocProvider(
            create: (context) => PurchaseCubit(
              paymentHandler: PaymentHandler(paymentType, context),
              product: product,
            ),
            child: BlocListener<PurchaseCubit, PurchaseState>(
              listener: (context, state) async {
                if (state is PurchaseCompleted) {
                  final payment = state.payment;
                  Navigator.pop<Payment>(context, payment);
                }
              },
              child: const PurchaseProcess(),
            ),
          ),
        );
      },
    );

import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/features/product/product_model.dart';
import 'package:coffeecard/features/purchase/data/repositories/payment_handler.dart';
import 'package:coffeecard/features/purchase/domain/entities/internal_payment_type.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:coffeecard/features/purchase/domain/usecases/init_purchase.dart';
import 'package:coffeecard/features/purchase/domain/usecases/verify_purchase_status.dart';
import 'package:coffeecard/features/purchase/presentation/cubit/purchase_cubit.dart';
import 'package:coffeecard/features/purchase/presentation/widgets/purchase_process.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<Payment?> showPurchaseOverlay({
  required BuildContext context,
  required Product product,
  required InternalPaymentType paymentType,
}) =>
    showDialog<Payment>(
      context: context,
      barrierColor: AppColors.scrim,
      barrierDismissible: false,
      builder: (_) {
        return PopScope(
          // Will prevent Android back button from closing overlay.
          canPop: false,
          child: BlocProvider(
            create: (context) {
              final paymentHandler =
                  PaymentHandler.createPaymentHandler(paymentType, context);

              return PurchaseCubit(
                product: product,
                initPurchase: InitPurchase(paymentHandler: paymentHandler),
                verifyPurchaseStatus:
                    VerifyPurchaseStatus(paymentHandler: paymentHandler),
              );
            },
            child: BlocListener<PurchaseCubit, PurchaseState>(
              listener: (context, state) {
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

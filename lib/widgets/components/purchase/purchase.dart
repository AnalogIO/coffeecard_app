import 'dart:async';

import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/payment/mobilepay_service.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

Future<Either<ApiError, Payment?>?> startPayment({
  required BuildContext context,
  required Product product,
}) {
  return showDialog<Either<ApiError, Payment?>>(
    barrierDismissible: false,
    barrierColor: AppColor.scrim,
    useRootNavigator: true,
    context: context,
    builder: (context) => PaymentHandler(product: product),
  );
}

class PaymentHandler extends StatefulWidget {
  const PaymentHandler({required this.product});
  final Product product;

  @override
  State<PaymentHandler> createState() => _PaymentHandlerState();
}

class _PaymentHandlerState extends State<PaymentHandler>
    with WidgetsBindingObserver {
  final _service = MobilePayService(sl.get<PurchaseRepository>());

  late Payment _payment;
  bool _shouldVerify = false;
  bool _shouldShowStatusText = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _verifyPayment();
    }
  }

  @override
  void initState() {
    _startPayment();

    // Display the status text after two seconds
    Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _shouldShowStatusText = true);
    });

    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColor.white),
            const Gap(24),
            Opacity(
              opacity: _shouldShowStatusText ? 1 : 0,
              child: Text(
                Strings.purchaseInProgress,
                style: AppTextStyle.explainerBright,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// - `popValue == Right(Payment)` means the payment was successful.
  /// - `popValue == Right(null)` means the payment was rejected.
  /// - `popValue == Left(ApiError)` means an API error occurred during payment.
  void _exit(Either<ApiError, Payment?> popValue) {
    Navigator.of(context).pop(popValue);
  }

  Future<void> _startPayment() async {
    final either = await _service.initPurchase(widget.product.id);
    if (either.isRight) {
      _payment = either.right;
      _shouldVerify = true;
      _service.invokeMobilePay(_payment.deeplink);
    } else {
      _exit(Left(either.left));
    }
  }

  Future<void> _verifyPayment() async {
    if (!_shouldVerify) return;
    _shouldVerify = false;
    final either = await _service.verifyPurchase(_payment.id);

    if (either.isLeft) {
      _exit(Left(either.left));
    } else {
      final paymentStatus = either.right;

      if (paymentStatus == PaymentStatus.completed) {
        _exit(Right(_payment));
      } else if (paymentStatus != PaymentStatus.reserved) {
        // Pop with no payment value (because it was cancelled/rejected)
        _exit(const Right(null));

        // TODO Consider if more error handling is needed
      } else {
        // Set status to processing to allow the verifyPurchase process again
        // _purchaseStatus = PurchaseProcessing(payment);
        _shouldVerify = true;

        // NOTE, recursive call, potentially infinite.
        // If payment has been reserved, i.e. approved by user
        // we will keep checking the backend to verify payment
        // has been captured
        _verifyPayment();
      }
    }
  }
}

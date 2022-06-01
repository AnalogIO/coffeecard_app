import 'dart:io';

import 'package:coffeecard/data/api/coffee_card_api_constants.dart';
import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/utils/launch.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class MobilePayService implements PaymentHandler {
  final PurchaseRepository _repository;
  final BuildContext _context;

  MobilePayService(this._repository, this._context);

  @override
  Future<Either<ApiError, Payment>> initPurchase(int productId) async {
    final response =
        await _repository.initiatePurchase(productId, PaymentType.mobilepay);

    if (response is Right) {
      final purchaseResponse = response.right;
      final paymentDetails = MobilePayPaymentDetails.fromJsonFactory(
        purchaseResponse.paymentDetails as Map<String, dynamic>,
      );

      return Right(
        Payment(
          id: purchaseResponse.id,
          paymentId: paymentDetails.paymentId!,
          status: PaymentStatus.awaitingPayment,
          deeplink: paymentDetails.mobilePayAppRedirectUri!,
          purchaseTime: purchaseResponse.dateCreated,
          price: purchaseResponse.totalAmount,
          productId: purchaseResponse.productId,
          productName: purchaseResponse.productName,
        ),
      );
    }
    return Left(response.left);
  }

  Future<void> invokeMobilePay(Uri mobilePayDeeplink) async {
    if (await canLaunchUrl(mobilePayDeeplink)) {
      await launchUrl(mobilePayDeeplink);
    } else {
      final Uri url;

      // MobilePay not installed, send user to appstore
      if (Platform.isAndroid) {
        url = CoffeeCardApiConstants.mobilepayAndroid;
      } else if (Platform.isIOS) {
        url = CoffeeCardApiConstants.mobilepayIOS;
      } else {
        throw 'Could not launch $mobilePayDeeplink';
      }

      launchUrlExternalApplication(url, _context);
    }
  }

  @override
  Future<Either<ApiError, PaymentStatus>> verifyPurchase(
    int purchaseId,
  ) async {
    // Call API endpoint, receive PaymentStatus
    final either = await _repository.getPurchase(purchaseId);

    if (either.isRight) {
      final paymentDetails = MobilePayPaymentDetails.fromJsonFactory(
        either.right.paymentDetails as Map<String, dynamic>,
      );

      final status = _mapPaymentStateToStatus(paymentDetails.state!);
      if (status == PaymentStatus.completed) {
        return const Right(PaymentStatus.completed);
      }
      // TODO: Cover more cases for PaymentStatus
      return const Right(PaymentStatus.error);
    }

    return Left(either.left);
  }

  PaymentStatus _mapPaymentStateToStatus(String state) {
    PaymentStatus status;
    switch (state) {
      case 'Initiated':
        status = PaymentStatus.awaitingPayment;
        break;
      case 'Reserved':
        status = PaymentStatus.reserved;
        break;
      case 'Captured':
        status = PaymentStatus.completed;
        break;
      // Cases (cancelledByMerchant, cancelledBySystem, cancelledByUser)
      default:
        status = PaymentStatus.rejectedPayment;
        break;
    }
    return status;
  }
}

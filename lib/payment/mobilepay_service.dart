import 'dart:io';

import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:coffeecard/utils/api_uri_constants.dart';
import 'package:coffeecard/utils/launch.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class MobilePayService implements PaymentHandler {
  final PurchaseRepository _repository;
  final BuildContext _context;

  MobilePayService(this._repository, this._context);

  @override
  Future<Either<Failure, Payment>> initPurchase(int productId) async {
    final response = await _repository.initiatePurchase(
      productId,
      PaymentType.mobilepay,
    );

    return response.map(
      (response) {
        final paymentDetails = MobilePayPaymentDetails.fromJsonFactory(
          response.paymentDetails,
        );

        return Payment(
          id: response.id,
          paymentId: paymentDetails.paymentId,
          status: PaymentStatus.awaitingPayment,
          deeplink: paymentDetails.mobilePayAppRedirectUri,
          purchaseTime: response.dateCreated,
          price: response.totalAmount,
          productId: response.productId,
          productName: response.productName,
        );
      },
    );
  }

  @override
  Future<void> invokePaymentMethod(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      final Uri url;

      // MobilePay not installed, send user to appstore
      if (Platform.isAndroid) {
        url = ApiUriConstants.mobilepayAndroid;
      } else if (Platform.isIOS) {
        url = ApiUriConstants.mobilepayIOS;
      } else {
        throw UnsupportedError('Unsupported platform');
      }
      if (_context.mounted) {
        launchUrlExternalApplication(url, _context);
      }
    }
  }

  @override
  Future<Either<ServerFailure, PaymentStatus>> verifyPurchase(
    int purchaseId,
  ) async {
    // Call API endpoint, receive PaymentStatus
    final either = await _repository.getPurchase(purchaseId);

    return either.map((purchase) {
      final paymentDetails =
          MobilePayPaymentDetails.fromJsonFactory(purchase.paymentDetails);

      final status = _mapPaymentStateToStatus(paymentDetails.state);
      if (status == PaymentStatus.completed) {
        return PaymentStatus.completed;
      }

      // TODO(marfavi): Cover more cases for PaymentStatus, https://github.com/AnalogIO/coffeecard_app/issues/385
      return PaymentStatus.error;
    });
  }

  PaymentStatus _mapPaymentStateToStatus(String? state) {
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

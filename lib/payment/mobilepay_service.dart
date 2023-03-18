import 'dart:developer';
import 'dart:io';

import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/purchase/initiate_purchase.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:coffeecard/utils/api_uri_constants.dart';
import 'package:coffeecard/utils/launch.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class MobilePayService extends PaymentHandler {
  final PurchaseRepository _repository;
  final BuildContext _context;

  MobilePayService({
    required super.repository,
    required super.context,
  })  : _repository = repository,
        _context = context;

  @override
  Future<Either<RequestFailure, Payment>> initPurchase(int productId) async {
    final Either<RequestFailure, InitiatePurchase> response;
    try {
      response = await _repository.initiatePurchase(
        productId,
        PaymentType.mobilepay,
      );
    } catch (e) {
      return Left(RequestFailure(e.toString()));
    }

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
}

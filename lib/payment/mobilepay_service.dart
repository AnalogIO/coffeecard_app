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
  Future<Either<Failure, Payment>> initPurchase(int productId) async {
    final Either<Failure, InitiatePurchase> response;
    response = await _repository.initiatePurchase(
      productId,
      PaymentType.mobilepay,
    );

    final either = response.map(
      (response) {
        final paymentDetails = MobilePayPaymentDetails.fromJsonFactory(
          response.paymentDetails,
        );

        return Payment(
          id: response.id,
          status: PaymentStatus.awaitingPayment,
          deeplink: paymentDetails.mobilePayAppRedirectUri,
          purchaseTime: response.dateCreated,
          price: response.totalAmount,
          productId: response.productId,
          productName: response.productName,
        );
      },
    );

    await _invokeMobilePayApp(either); // Sideeffect

    return either;
  }

  Future<void> _invokeMobilePayApp(
    Either<Failure, Payment> paymentEither,
  ) async {
    paymentEither.map(
      (payment) async {
        final Uri mobilepayLink = Uri.parse(payment.deeplink);

        if (await canLaunchUrl(mobilepayLink)) {
          await launchUrl(mobilepayLink, mode: LaunchMode.externalApplication);

          return;
        } else {
          final Uri url = _getAppStoreUri();

          // MobilePay not installed, send user to appstore
          if (_context.mounted) {
            await launchUrlExternalApplication(url, _context);
          }
        }
      },
    );
  }

  Uri _getAppStoreUri() {
    if (Platform.isAndroid) {
      return ApiUriConstants.mobilepayAndroid;
    } else if (Platform.isIOS) {
      return ApiUriConstants.mobilepayIOS;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}

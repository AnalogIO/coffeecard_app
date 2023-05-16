import 'dart:io';

import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/purchase/initiate_purchase.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:coffeecard/utils/api_uri_constants.dart';
import 'package:coffeecard/utils/launch.dart';
import 'package:fpdart/fpdart.dart';
import 'package:url_launcher/url_launcher.dart';

class MobilePayService extends PaymentHandler {
  MobilePayService({
    required super.purchaseRepository,
    required super.context,
  });
  @override
  Future<Either<Failure, Payment>> initPurchase(int productId) async {
    final Either<Failure, InitiatePurchase> response;
    response = await purchaseRepository.initiatePurchase(
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
    final _ = paymentEither.map(
      (payment) async {
        final Uri mobilepayLink = Uri.parse(payment.deeplink);

        if (await canLaunchUrl(mobilepayLink)) {
          final _ = await launchUrl(
            mobilepayLink,
            mode: LaunchMode.externalApplication,
          );

          return;
        } else {
          final Uri url = _getAppStoreUri();

          // MobilePay not installed, send user to appstore
          if (context.mounted) {
            await launchUrlExternalApplication(url, context);
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

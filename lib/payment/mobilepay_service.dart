import 'dart:io';

import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class MobilePayService implements PaymentHandler {
  final PurchaseRepository _repository;
  final Logger _logger;

  MobilePayService(this._repository, this._logger);

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
        //FIXME: should these URL's be stored somewhere?
        url = Uri.parse('market://details?id=dk.danskebank.mobilepay');
      } else if (Platform.isIOS) {
        url = Uri.parse('itms-apps://itunes.apple.com/app/id624499138');
      } else {
        throw 'Could not launch $mobilePayDeeplink';
      }

      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        _logger.i('could not launch $url');
      }
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
      //TODO Cover more cases for PaymentStatus
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
      default: //cancelledByMerchant, cancelledBySystem, cancelledByUser
        status = PaymentStatus.rejectedPayment;
        break;
    }
    return status;
  }
}

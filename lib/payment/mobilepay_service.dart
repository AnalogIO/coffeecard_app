import 'dart:io';

import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:url_launcher/url_launcher.dart';

class MobilePayService {
  final PurchaseRepository _repository;

  const MobilePayService(this._repository);

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
          id: purchaseResponse.id!,
          paymentId: paymentDetails.paymentId!,
          status: PaymentStatus.awaitingPayment,
          deeplink: paymentDetails.mobilePayAppRedirectUri!,
          purchaseTime: purchaseResponse.dateCreated!,
          price: purchaseResponse.totalAmount!,
        ),
      );
    }
    return Left(response.left);
  }

  Future<void> invokeMobilePay(String mobilePayDeeplink) async {
    if (await canLaunch(mobilePayDeeplink)) {
      await launch(mobilePayDeeplink, forceSafariVC: false);
    } else {
      // MobilePay not installed, send user to appstore
      final String url;

      if (Platform.isAndroid) {
        //FIXME: should these URL's be stored somewhere?
        url = 'market://details?id=dk.danskebank.mobilepay';
      } else if (Platform.isIOS) {
        url = 'itms-apps://itunes.apple.com/app/id624499138';
      } else {
        throw 'Could not launch $mobilePayDeeplink';
      }

      await launch(url);
    }
  }

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
    switch (state) {
      case 'Initiated':
        return PaymentStatus.awaitingPayment;
      case 'Reserved':
        return PaymentStatus.reserved;
      case 'Captured':
        return PaymentStatus.completed;
      default: // cancelledByMerchant, cancelledBySystem, cancelledByUser
        return PaymentStatus.rejectedPayment;
    }
  }
}

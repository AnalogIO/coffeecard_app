import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.swagger.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/widgets/popup_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

part 'mobilepay_service.dart';

enum InternalPaymentType {
  mobilePay,
  applePay,
}

abstract class PaymentHandler {
  factory PaymentHandler(InternalPaymentType type, BuildContext context) {
    switch (type) {
      case InternalPaymentType.mobilePay:
        return MobilePayService(context, sl.get<PurchaseRepository>());
      case InternalPaymentType.applePay:
        throw UnimplementedError();
    }
  }

  /*
  Proposed new API:

  //Calls API, parse deeplink MobilePay, checks Payment status and returns successful or error.
  //I got the idea that we could do it more functional with Either instead of throwing exceptions.
  Either<SuccessfulType, ErrorType> purchase(int productId)

  //Gives user a current status of purchase, used to re-init purchase or other control flow
  Either<SuccessfulType, ErrorType> verifyPurchase(some relevant identifier)
  */

  Future<Payment> initPurchase(int productId);
  Future<PaymentStatus> verifyPurchaseOrRetry(int purchaseId);

  void onSuccess(BuildContext context);
  void onFailure(BuildContext context);
  void onCancel(BuildContext context);
}

class Payment {
  final String paymentId;
  final String deeplink;

  Payment({required this.paymentId, required this.deeplink});
}

enum PaymentStatus {
  completed, //payment is completed
  error, //mobilepay error
  waiting, //payment is not yet complete
  awaitingPayment, //user has not approved the purchase
  rejectedPayment, //user has rejected payment
  awaitingCompletionAfterRetry
}

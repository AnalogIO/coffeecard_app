import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/payment/mobilepay_service.dart';
import 'package:coffeecard/service_locator.dart';

enum InternalPaymentType {
  mobilePay,
  applePay,
}

abstract class PaymentHandler {
  factory PaymentHandler(InternalPaymentType type) {
    switch (type) {
      case InternalPaymentType.mobilePay:
        return MobilePayService(sl.get<PurchaseRepository>());
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
//TODO consider if these need re-adding, else remove
/*
  void onSuccess(BuildContext context);
  void onFailure(BuildContext context);
  void onCancel(BuildContext context);*/
}

class Payment {
  final int id;
  final String paymentId;
  final PaymentStatus status;
  final String deeplink;
  final int price;
  final DateTime purchaseTime;
  final String productName;

  Payment({
    required this.id,
    required this.price,
    required this.purchaseTime,
    required this.productName,
    required this.paymentId,
    required this.status,
    required this.deeplink,
  });
}

enum PaymentStatus {
  completed, //payment is completed
  error, //mobilepay error
  waiting, //payment is not yet complete
  awaitingPayment, //user has not approved the purchase
  rejectedPayment, //user has rejected payment
  awaitingCompletionAfterRetry
}

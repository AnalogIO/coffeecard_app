import 'package:flutter/services.dart';

enum PaymentType {
  mobilePay,
  applePay,
}

abstract class PaymentService {
  factory PaymentService(PaymentType type) {
    switch (type) {
      case PaymentType.mobilePay:
        return MobilePayService();
      case PaymentType.applePay:
        throw UnimplementedError();
    }
  }

  Payment initPurchase(String productId);
  void invokeMobilePay(Payment po);
  PaymentStatus verifyPurchaseOrRetry(String paymentId);
}

class MobilePayService implements PaymentService {
  static const platform = MethodChannel('samples.flutter.dev');

  MobilePayService();

  @override
  Payment initPurchase(String productId) {
    // Call coffeecard API with productId
    //errors:
    //  networkerror: retry?
    //  else:         log and report error

    Payment payment;
    try {
      // Receive mobilepayId and deeplink from API
      payment = Payment(paymentId: '', deeplink: ''); //call API

      return Payment(paymentId: payment.paymentId, deeplink: payment.deeplink);
    } catch (e) {
      //TODO: handle errors
    }

    throw UnimplementedError();
  }

  @override
  Future<void> invokeMobilePay(Payment po) async {
    // Open Mobilepay app with paymentId and deeplink
    await platform.invokeMethod(
      'foo',
      {'price': 10.0, 'orderId': '86715c57-8840-4a6f-af5f-07ee89107ece'},
    );
  }

  @override
  PaymentStatus verifyPurchaseOrRetry(String paymentId) {
    // Call API endpoint, receive PaymentStatus
    const PaymentStatus status = PaymentStatus.error; //TODO: call API

    if (status != PaymentStatus.waiting) {
      return status;
    }

    //retry X times?
    //  not success after X retries: return PaymentStatus.awaitingCompletionAfterRetry

    throw UnimplementedError();
  }
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

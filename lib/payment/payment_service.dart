abstract class PaymentService {
  factory PaymentService() {
    /*
      switch PAYMENT
      case MOBILEPAY: return MobilePayService();
      case GPAY: return ...
      case ApplePay: return ...
      */
    return MobilePayService();
  }

  Payment initPurchase(String productId);
  void invokeMobilePay(Payment po);
  PaymentStatus verifyPurchaseOrRetry(String paymentId);
}

class MobilePayService implements PaymentService {
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
  void invokeMobilePay(Payment po) {
    // Open Mobilepay app with paymentId and deeplink
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

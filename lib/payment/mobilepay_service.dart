part of 'payment_handler.dart';

class MobilePayService implements PaymentHandler {
  static const platform = MethodChannel('analog.mobilepay');

  final BuildContext context;

  MobilePayService(this.context);

  //FIXME: handle BuildContext in a smarter way?
  Future<void> _callbackHandler(MethodCall call) async {
    switch (call.method) {
      case 'onSuccess':
        onSuccess(context);
        break;
      case 'onFailure':
        onFailure(context);
        break;
      case 'onCancel':
        onCancel(context);
        break;
    }
  }

  @override
  void onSuccess(BuildContext context) {
    //FIXME: use real logic
    showDialog(
      context: context,
      builder: (context) {
        return const PopupCard(title: 'Success', content: 'Looks good?');
      },
    );
  }

  @override
  void onFailure(BuildContext context) {
    //FIXME: use real logic
    showDialog(
      context: context,
      builder: (context) {
        return const PopupCard(title: 'Failure', content: 'Looks good?');
      },
    );
  }

  @override
  void onCancel(BuildContext context) {
    //FIXME: use real logic
    showDialog(
      context: context,
      builder: (context) {
        return const PopupCard(title: 'Cancel', content: 'Looks good?');
      },
    );
  }

  @override
  Future<Payment> initPurchase(int productId) async {
    // ignore: unused_local_variable
    final PurchaseRepository _purchaseRepository = sl.get<PurchaseRepository>();
    // Call coffeecard API with productId
    //errors:
    //  networkerror: retry?
    //  else:         log and report error

    // Receive mobilepayId and deeplink from API
    //FIXME: call api
    final InitiatePurchaseResponse response = InitiatePurchaseResponse(
      id: 122,
      dateCreated: DateTime.now(),
      productId: 1,
      totalAmount: 100,
      purchaseStatus: 'PendingPayment',
      paymentDetails: {
        'paymentType': 'MobilePay',
        'orderId': 'f5cb3e0f-3b9b-4f50-8c4f-a7450f300a5c',
        'mobilePayAppRedirectUri':
            'mobilepay://merchant_payments?payment_id=186d2b31-ff25-4414-9fd1-bfe9807fa8b7',
        'paymentId': '186d2b31-ff25-4414-9fd1-bfe9807fa8b7'
      },
    );
    //await _purchaseRepositoryinitiatePurchase(productId, PaymentType.mobilepay);

    final Map<String, String> paymentDetails =
        response.paymentDetails as Map<String, String>;

    return Payment(
      paymentId: paymentDetails['paymentId']!,
      deeplink: paymentDetails['mobilePayAppRedirectUri']!,
    );
  }

  //FIXME: should use mobilepay deeplink
  void invokeMobilePay(String paymentId, int price) {
    platform.setMethodCallHandler(_callbackHandler);

    // Open Mobilepay app with paymentId and deeplink
    platform.invokeMethod(
      'openMobilepay',
      {'price': price.toDouble(), 'orderId': paymentId},
    );
  }

  @override
  Future<PaymentStatus> verifyPurchaseOrRetry(
    int purchaseId,
  ) async {
    final PurchaseRepository _purchaseRepository = sl.get<PurchaseRepository>();

    // Call API endpoint, receive PaymentStatus
    final Purchase purchase = await _purchaseRepository.getPurchase(purchaseId);

    return purchase.purchaseStatus as PaymentStatus;
  }
}

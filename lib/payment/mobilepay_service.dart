part of 'payment_handler.dart';

class MobilePayService implements PaymentHandler {
  static const platform = MethodChannel('analog.mobilepay');

  final BuildContext context;
  final PurchaseRepository _repository;

  MobilePayService(this.context, this._repository);

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
    final response = await _repository.initiatePurchase(productId, PaymentType.mobilepay);

    if (response is Right) {
      return Payment(
        //TODO handle the types better
        paymentId: response.right.paymentDetails['paymentId']!,
        deeplink: response.right.paymentDetails['mobilePayAppRedirectUri']!,
      );
    }
    return Payment(paymentId: "paymentId", deeplink: "deeplink"); //TODO do proper error handling
  }

  //FIXME: should use mobilepay deeplink
  Future invokeMobilePay(String mobilePayDeeplink) async {
    if (await canLaunch(mobilePayDeeplink)) {
      await launch(mobilePayDeeplink, forceSafariVC: false);
    } else {
      // MobilePay not installed
      throw 'Could not launch $mobilePayDeeplink';
    }
  }

  @override
  Future<PaymentStatus> verifyPurchaseOrRetry(
    int purchaseId,
  ) async {
    // Call API endpoint, receive PaymentStatus
    final either = await _repository.getPurchase(purchaseId);

    if (either.isRight) {
      return either.right.purchaseStatus as PaymentStatus;
    }

    //FIXME
    throw Exception('not implemented');
  }
}

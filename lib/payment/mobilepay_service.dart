import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.swagger.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:url_launcher/url_launcher.dart';

class MobilePayService implements PaymentHandler {
  final PurchaseRepository _repository;

  MobilePayService(this._repository);

  @override
  Future<Payment> initPurchase(int productId) async {
    final response =
        await _repository.initiatePurchase(productId, PaymentType.mobilepay);

    if (response is Right) {
      PaymentStatus status;
      switch (purchaseStatusFromJson(response.right.purchaseStatus)) {
        case PurchaseStatus.pendingpayment:
          status = PaymentStatus.awaitingPayment;
          break;
        default:
          status = PaymentStatus
              .error; //Any other status codes than pending payment should not occur here
          break;
      }
      return Payment(
        //TODO handle the types better
        id: response.right.id!,
        // ignore: avoid_dynamic_calls
        paymentId: response.right.paymentDetails['paymentId']! as String,
        status: status,
        deeplink:
            // ignore: avoid_dynamic_calls
            response.right.paymentDetails['mobilePayAppRedirectUri']! as String,
      );
    }
    return Payment(
      id: 0,
      paymentId: 'paymentId',
      status: PaymentStatus.error,
      deeplink: 'deeplink',
    ); //TODO do proper error handling
  }

  //FIXME: should use mobilepay deeplink
  Future invokeMobilePay(String mobilePayDeeplink) async {
    if (await canLaunch(mobilePayDeeplink)) {
      await launch(mobilePayDeeplink, forceSafariVC: false);
    } else {
      //TODO better handling, likely send user to appstore
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
      final status = purchaseStatusFromJson(either.right.purchaseStatus);
      if (status == PurchaseStatus.completed) {
        return PaymentStatus.completed;
      }
      //TODO Cover more cases for PaymentStatus
      return PaymentStatus.error;
    }

    //FIXME
    throw Exception('not implemented');
  }
}

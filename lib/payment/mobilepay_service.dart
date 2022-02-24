import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:url_launcher/url_launcher.dart';

class MobilePayService implements PaymentHandler {
  final PurchaseRepository _repository;

  MobilePayService(this._repository);

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
          id: purchaseResponse.id!,
          paymentId: paymentDetails.paymentId!,
          status: PaymentStatus.awaitingPayment,
          deeplink: paymentDetails.mobilePayAppRedirectUri!,
          purchaseTime: purchaseResponse.dateCreated!,
          price: purchaseResponse.totalAmount!,
          productName: 'Placeholder',
          //TODO consider whether the product name should be passed by the original widget that is pressed to start the purchase flow, or get it from the backend
        ),
      );
    }
    return Left(response.left);
  }

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
        status = PaymentStatus.waiting;
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

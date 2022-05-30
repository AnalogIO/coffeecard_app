import 'package:bloc/bloc.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/payment/mobilepay_service.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

part 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final PaymentHandler paymentHandler;
  final Product product;

  PurchaseCubit({required this.paymentHandler, required this.product})
      : super(const PurchaseInitial());

  Future<void> payWithApplePay() async {
    // TODO: implement me
    throw UnimplementedError();
  }

  Future<void> payWithMobilePay() async {
    if (state is PurchaseInitial) {
      sl<FirebaseAnalytics>().logBeginCheckout(
        value: product.price.toDouble(),
        currency: 'DKK',
        items: [
          AnalyticsEventItem(
            itemId: product.id.toString(),
            itemName: product.name,
          )
        ],
      );
      emit(const PurchaseStarted());
      // TODO: Consider if cast can be removed/ abstracted away
      final MobilePayService service = paymentHandler as MobilePayService;

      final either = await service.initPurchase(product.id);
      if (either.isRight) {
        final Payment payment = either.right;

        if (payment.status != PaymentStatus.error) {
          emit(PurchaseProcessing(payment));
          await service.invokeMobilePay(Uri.parse(payment.deeplink));
        } else {
          emit(PurchasePaymentRejected(payment));
        }
      } else {
        emit(PurchaseError(either.left.message));
      }
    }
  }

  /// Verifies the status of the current purchase
  /// Only checks the status of the purchase if the state is PurchaseProcessing
  Future<void> verifyPurchase() async {
    if (state is PurchaseProcessing) {
      final payment = (state as PurchaseProcessing).payment;
      emit(PurchaseVerifying(payment));
      final either = await paymentHandler.verifyPurchase(payment.id);

      if (either.isRight) {
        final status = either.right;

        if (status == PaymentStatus.completed) {
          sl<FirebaseAnalytics>().logPurchase(
            currency: 'DKK',
            value: payment.price.toDouble(),
            items: [
              AnalyticsEventItem(
                itemId: payment.productId.toString(),
                itemName: payment.productName,
              )
            ],
            transactionId: payment.id.toString(),
          );
          emit(PurchaseCompleted(payment.copyWith(status: status)));
        } else if (status == PaymentStatus.reserved) {
          // NOTE, recursive call, potentially infinite.
          // If payment has been reserved, i.e. approved by user
          // we will keep checking the backend to verify payment has been captured

          // Emit processing state to allow the verifyPurchase process again
          emit(
            PurchaseProcessing(
              payment.copyWith(status: status),
            ),
          );
          verifyPurchase();
        } else {
          emit(PurchasePaymentRejected(payment.copyWith(status: status)));
          // TODO: Consider if more error handling is needed
        }
      } else {
        emit(PurchaseError(either.left.message));
      }
    }
  }
}

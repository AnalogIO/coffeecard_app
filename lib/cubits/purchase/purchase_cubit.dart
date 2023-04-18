import 'package:bloc/bloc.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/firebase_analytics_event_logging.dart';
import 'package:equatable/equatable.dart';

part 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final PaymentHandler paymentHandler;
  final Product product;

  PurchaseCubit({required this.paymentHandler, required this.product})
      : super(const PurchaseInitial());

  Future<void> pay() async {
    sl<FirebaseAnalyticsEventLogging>().beginCheckoutEvent(product);

    if (state is PurchaseInitial) {
      emit(const PurchaseStarted());

      final either = await paymentHandler.initPurchase(product.id);

      either.fold(
        (error) => emit(PurchaseError(error.reason)),
        (payment) {
          if (payment.status == PaymentStatus.completed) {
            emit(PurchaseCompleted(payment));
          } else if (payment.status == PaymentStatus.awaitingPayment) {
            emit(PurchaseProcessing(payment));
          } else {
            emit(PurchasePaymentRejected(payment));
          }
        },
      );
    }
  }

  /// Verifies the status of the current purchase
  /// Only checks the status of the purchase if the state is PurchaseProcessing
  Future<void> verifyPurchase() async {
    if (state is PurchaseProcessing) {
      final payment = (state as PurchaseProcessing).payment;
      emit(PurchaseVerifying(payment));
      final either = await paymentHandler.verifyPurchase(payment.id);

      either.fold(
        (error) => emit(PurchaseError(error.reason)),
        (status) {
          if (status == PaymentStatus.completed) {
            sl<FirebaseAnalyticsEventLogging>().purchaseCompletedEvent(payment);
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
          }
        },
      );
    }
  }
}

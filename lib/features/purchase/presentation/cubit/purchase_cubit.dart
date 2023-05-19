import 'package:bloc/bloc.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:coffeecard/features/purchase/domain/usecases/init_purchase.dart';
import 'package:coffeecard/features/purchase/domain/usecases/verify_purchase_status.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/firebase_analytics_event_logging.dart';
import 'package:equatable/equatable.dart';

part 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final Product product;
  final InitPurchase initPurchase;
  final VerifyPurchaseStatus verifyPurchaseStatus;

  PurchaseCubit({
    required this.product,
    required this.initPurchase,
    required this.verifyPurchaseStatus,
  }) : super(const PurchaseInitial());

  /// Initialise a purchase of [product]
  Future<void> pay() async {
    sl<FirebaseAnalyticsEventLogging>().beginCheckoutEvent(product);

    if (state is! PurchaseInitial) {
      return;
    }

    emit(const PurchaseStarted());

    final either = await initPurchase(product.id);

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

  /// Verify the status of the current purchase
  Future<void> verifyPurchase() async {
    if (state is! PurchaseProcessing) {
      return;
    }

    final payment = (state as PurchaseProcessing).payment;

    emit(PurchaseVerifying(payment));

    checkPurchaseStatus(
      payment,
      () => validatePurchaseStatusAtInterval(payment),
    );
  }

  /// Check the status of the current purchase at an interval and aborts
  /// with a timeout if too long has passed
  Future<void> validatePurchaseStatusAtInterval(
    Payment payment, {
    int iteration = 0,
  }) async {
    const maxIterations = 3;
    const delay = Duration(seconds: 1);

    if (iteration >= maxIterations) {
      emit(PurchaseTimeout(payment));
      return;
    }

    final _ = await Future.delayed(delay);

    // If payment has been reserved, i.e. approved by user
    // we will keep checking the backend to verify payment has been captured
    checkPurchaseStatus(
      payment,
      () => validatePurchaseStatusAtInterval(payment, iteration: iteration + 1),
    );
  }

  /// Check the status of [payment] and invoke [onPending]
  /// if the payment is still pending
  Future<void> checkPurchaseStatus(
    Payment payment,
    Future<void> Function() onPending,
  ) async {
    final either = await verifyPurchaseStatus(payment.id);

    either.fold(
      (error) => emit(PurchaseError(error.reason)),
      (status) async {
        switch (status) {
          case PaymentStatus.completed:
            sl<FirebaseAnalyticsEventLogging>().purchaseCompletedEvent(payment);
            emit(PurchaseCompleted(payment.copyWith(status: status)));
          case PaymentStatus.error:
            emit(PurchasePaymentRejected(payment.copyWith(status: status)));
          case PaymentStatus.reserved:
          case PaymentStatus.awaitingPayment:
            await onPending();
          case PaymentStatus.rejectedPayment:
            emit(PurchasePaymentRejected(payment));
          case PaymentStatus.refunded:
            emit(PurchasePaymentRejected(payment));
        }
      },
    );
  }
}

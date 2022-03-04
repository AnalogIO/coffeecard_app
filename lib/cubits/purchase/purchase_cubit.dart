import 'package:bloc/bloc.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/payment/mobilepay_service.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:equatable/equatable.dart';

part 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final PaymentHandler paymentHandler;
  final Product product;

  PurchaseCubit({required this.paymentHandler, required this.product})
      : super(const PurchaseInitial());

  Future<void> payWithApplePay() async {
    //TODO implement me
    throw UnimplementedError();
  }

  Future<void> payWithMobilePay() async {
    if (state is PurchaseInitial) {
      emit(const PurchaseStarted());
      //FIXME: Consider if cast can be removed/ abstracted away
      final MobilePayService service = paymentHandler as MobilePayService;

      final either = await service.initPurchase(product.id);
      if (either.isRight) {
        final Payment payment = either.right;

        if (payment.status != PaymentStatus.error) {
          emit(PurchaseProcessing(payment));
          await service.invokeMobilePay(payment.deeplink);
        } else {
          emit(PurchasePaymentRejected(payment));
        }
      } else {
        emit(PurchaseError(either.left.errorMessage));
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
          emit(PurchaseCompleted(payment));
        } else if (status == PaymentStatus.reserved) {
          //NOTE, recursive call, potentially infinite.
          //If payment has been reserved, i.e. approved by user
          //we will keep checking the backend to verify payment has been captured
          emit(
            PurchaseProcessing(
              payment,
            ),
          ); //Change to processing to allow the verifyPurchase process again
          verifyPurchase();
        } else {
          emit(PurchasePaymentRejected(payment));
          //TODO Consider if more error handling is needed
        }
      } else {
        emit(PurchaseError(either.left.errorMessage));
      }
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/payment/mobilepay_service.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:equatable/equatable.dart';

part 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final PaymentHandler _paymentHandler;
  final Product product;

  PurchaseCubit(this._paymentHandler, this.product)
      : super(const PurchaseInitial());

  Future<void> payWithApplePay() async {
    //TODO implement me
    throw UnimplementedError();
  }

  Future<void> payWithMobilePay() async {
    if (state is PurchaseInitial) {
      emit(const PurchaseStarted());
      //FIXME: Consider if cast can be removed/ abstracted away
      final MobilePayService service = _paymentHandler as MobilePayService;

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

  Future<void> verifyPurchase() async {
    if (state is PurchaseProcessing || state is PurchaseVerifying) {
      final previousState = state as PurchaseProcessing;
      emit(PurchaseVerifying(previousState.payment));
      final either =
          await _paymentHandler.verifyPurchase(previousState.payment.id);

      if (either.isRight) {
        final status = either.right;

        if (status == PaymentStatus.completed) {
          emit(PurchaseCompleted(previousState.payment));
        } else if (status == PaymentStatus.reserved) {
          //NOTE, recursive call, potentially infinite.
          //If payment has been reserved, i.e. approved by user
          //we will keep checking the backend to verify payment has been captured
          verifyPurchase();
        } else {
          emit(PurchasePaymentRejected(previousState.payment));
          //TODO Consider if more error handling is needed
        }
      } else {
        emit(PurchaseError(either.left.errorMessage));
      }
    }
  }
}

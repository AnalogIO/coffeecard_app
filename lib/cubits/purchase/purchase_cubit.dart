import 'package:bloc/bloc.dart';
import 'package:coffeecard/payment/mobilepay_service.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:equatable/equatable.dart';

part 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final PaymentHandler _paymentHandler;
  final int productId;

  PurchaseCubit(this._paymentHandler, this.productId)
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

      final Payment payment = await service.initPurchase(productId);
      if (payment.status != PaymentStatus.error) {
        emit(PurchaseProcessing(payment));
        await service.invokeMobilePay(payment.deeplink);
      } else {
        emit(PurchaseError(payment));
        //TODO Consider if more error handling is needed
      }
    }
  }

  Future<void> verifyPurchase() async {
    if (state is PurchaseProcessing) {
      final previousState = state as PurchaseProcessing;
      emit(PurchaseVerifying(previousState.payment));
      final status =
          await _paymentHandler.verifyPurchaseOrRetry(previousState.payment.id);
      if (status == PaymentStatus.completed) {
        emit(PurchaseCompleted(previousState.payment));
      } else {
        emit(PurchaseError(previousState.payment));
        //TODO Consider if more error handling is needed
      }
    }
  }
}

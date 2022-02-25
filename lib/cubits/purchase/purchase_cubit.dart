import 'package:bloc/bloc.dart';
import 'package:coffeecard/payment/mobilepay_service.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:coffeecard/utils/either.dart';
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

      final purchaseResponse = await service.initPurchase(productId);
      if (purchaseResponse is Right) {
        final Payment payment = purchaseResponse.right;
        if (payment.status != PaymentStatus.error) {
          emit(PurchaseProcessing(payment));
          await service.invokeMobilePay(payment.deeplink);
        } else {
          emit(PurchaseError(payment));
          //TODO Consider if more error handling is needed
          //TODO Handle case where user went to app store
        }
      } else if (purchaseResponse is Left) {
        throw 'Unhandled case';
        //TODO Add error handling
      }
    }
  }

  Future<void> verifyPurchase() async {
    if (state is PurchaseProcessing) {
      final previousState = state as PurchaseProcessing;
      emit(PurchaseVerifying(previousState.payment));
      final verificationResponse =
          await _paymentHandler.verifyPurchase(previousState.payment.id);

      if (verificationResponse is Right) {
        final status = verificationResponse.right;

        if (status == PaymentStatus.completed) {
          emit(PurchaseCompleted(previousState.payment));
        } else {
          emit(PurchaseError(previousState.payment));
          //TODO Consider if more error handling is needed
        }
      } else if (verificationResponse is Left) {
        emit(PurchaseError(previousState.payment));
      }
    }
  }
}

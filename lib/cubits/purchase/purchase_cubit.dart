import 'package:bloc/bloc.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:equatable/equatable.dart';

part 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final MobilePayService _mobilePayService;
  PurchaseCubit(this._mobilePayService) : super(PurchaseInitial());

  Future<void> payWithApplePay(int id, int price) async {
    throw UnimplementedError();
  }

  Future<void> payWithMobilePay(int id, int price) async {
    //FIXME: remove cast once new MP implementation is done
    final MobilePayService service =
    PaymentHandler(InternalPaymentType.mobilePay, context)
    as MobilePayService;

    final Payment payment = await service.initPurchase(id);
    await service.invokeMobilePay(payment.deeplink);
  }
}

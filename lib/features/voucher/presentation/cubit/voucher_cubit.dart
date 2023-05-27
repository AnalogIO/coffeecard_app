import 'package:bloc/bloc.dart';
import 'package:coffeecard/features/voucher/domain/entities/redeemed_voucher.dart';
import 'package:coffeecard/features/voucher/domain/usecases/redeem_voucher_code.dart';
import 'package:equatable/equatable.dart';

part 'voucher_state.dart';

class VoucherCubit extends Cubit<VoucherState> {
  final RedeemVoucherCode redeemVoucherCode;

  VoucherCubit({required this.redeemVoucherCode}) : super(VoucherInitial());

  Future<void> redeemVoucher(String voucher) async {
    emit(VoucherLoading());

    final either = await redeemVoucherCode(voucher);

    either.fold(
      (error) => emit(VoucherError(error.reason)),
      (redeemedVoucher) => emit(VoucherSuccess(redeemedVoucher)),
    );
  }
}

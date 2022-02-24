import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/v1/voucher_repository.dart';
import 'package:coffeecard/models/voucher/redeemed_voucher.dart';
import 'package:equatable/equatable.dart';

part 'voucher_state.dart';

class VoucherCubit extends Cubit<VoucherState> {
  VoucherCubit(this._voucherRepository) : super(VoucherInitial());

  final VoucherRepository _voucherRepository;

  Future<void> redeemVoucher(String voucher) async {
    emit(VoucherLoading());
    final either = await _voucherRepository.redeemVoucher(voucher);

    if (either.isRight) {
      emit(VoucherSuccess(either.right));
    } else {
      emit(VoucherError(either.left.errorMessage));
    }
  }
}

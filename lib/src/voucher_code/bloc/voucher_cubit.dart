import 'package:bloc/bloc.dart';
import 'package:coffeecard/features/voucher_code.dart';
import 'package:equatable/equatable.dart';

part 'voucher_state.dart';

class VoucherCubit extends Cubit<VoucherState> {
  VoucherCubit({required this.voucherCodeRepository})
      : super(const VoucherInitial());

  final VoucherCodeRepository voucherCodeRepository;

  Future<void> redeemVoucherCode(String voucher) {
    emit(const VoucherLoading());

    return voucherCodeRepository
        .redeemVoucherCode(voucher)
        .match(
          (error) => VoucherError(error.reason),
          VoucherSuccess.new,
        )
        .map(emit)
        .run();
  }
}

part of 'voucher_cubit.dart';

sealed class VoucherState extends Equatable {
  const VoucherState();

  @override
  List<Object> get props => [];
}

class VoucherInitial extends VoucherState {
  const VoucherInitial();
}

class VoucherLoading extends VoucherState {
  const VoucherLoading();
}

// FIXME: Make error states a common class?
class VoucherError extends VoucherState {
  const VoucherError(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

class VoucherSuccess extends VoucherState {
  final RedeemedVoucher redeemedVoucher;

  const VoucherSuccess(this.redeemedVoucher);

  @override
  List<Object> get props => [redeemedVoucher];
}

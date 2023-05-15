part of 'voucher_cubit.dart';

sealed class VoucherState extends Equatable {
  const VoucherState();

  @override
  List<Object> get props => [];
}

class VoucherInitial extends VoucherState {}

class VoucherLoading extends VoucherState {}

class VoucherError extends VoucherState {
  final String error;
  const VoucherError(this.error);
  @override
  List<Object> get props => [error];
}

class VoucherSuccess extends VoucherState {
  final RedeemedVoucher redeemedVoucher;
  const VoucherSuccess(this.redeemedVoucher);

  @override
  List<Object> get props => [redeemedVoucher];
}

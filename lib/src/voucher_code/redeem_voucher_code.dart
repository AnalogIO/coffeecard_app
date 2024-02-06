import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/voucher_code.dart';
import 'package:fpdart/fpdart.dart';

class RedeemVoucherCode {
  final VoucherRemoteDataSource dataSource;

  RedeemVoucherCode({required this.dataSource});

  Future<Either<Failure, RedeemedVoucher>> call(String voucher) {
    return dataSource.redeemVoucher(voucher);
  }
}

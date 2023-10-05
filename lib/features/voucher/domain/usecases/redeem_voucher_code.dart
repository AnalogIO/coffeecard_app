import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/voucher/data/datasources/voucher_remote_data_source.dart';
import 'package:coffeecard/features/voucher/domain/entities/redeemed_voucher.dart';
import 'package:fpdart/fpdart.dart';

class RedeemVoucherCode {
  final VoucherRemoteDataSource dataSource;

  RedeemVoucherCode({required this.dataSource});

  Future<Either<Failure, RedeemedVoucher>> call(String voucher) {
    return dataSource.redeemVoucher(voucher);
  }
}

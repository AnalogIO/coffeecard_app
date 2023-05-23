import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/voucher/data/datasources/voucher_remote_data_source.dart';
import 'package:coffeecard/features/voucher/domain/entities/redeemed_voucher.dart';
import 'package:fpdart/fpdart.dart';

class RedeemVoucherCode implements UseCase<RedeemedVoucher, String> {
  final VoucherRemoteDataSource remoteDataSource;

  RedeemVoucherCode({required this.remoteDataSource});

  @override
  Future<Either<Failure, RedeemedVoucher>> call(String voucher) {
    return remoteDataSource.redeemVoucher(voucher);
  }
}

import 'package:coffeecard/core/errors/exceptions.dart';
import 'package:coffeecard/core/network/executor.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/models/voucher/redeemed_voucher.dart';
import 'package:dartz/dartz.dart';

class VoucherRepository {
  VoucherRepository({
    required this.apiV1,
    required this.executor,
  });

  final CoffeecardApi apiV1;
  final Executor executor;

  Future<Either<RequestFailure, RedeemedVoucher>> redeemVoucher(
    String voucher,
  ) async {
    try {
      final result = await executor(
        () => apiV1.apiV1PurchasesRedeemvoucherPost(voucherCode: voucher),
      );

      return Right(RedeemedVoucher.fromDTO(result!));
    } on ServerException catch (e) {
      return Left(RequestFailure(e.error));
    }
  }
}

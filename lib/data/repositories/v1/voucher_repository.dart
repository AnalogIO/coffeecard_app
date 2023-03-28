import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/models/voucher/redeemed_voucher.dart';
import 'package:dartz/dartz.dart';

class VoucherRepository {
  VoucherRepository({
    required this.apiV1,
    required this.executor,
  });

  final CoffeecardApi apiV1;
  final NetworkRequestExecutor executor;

  Future<Either<NetworkFailure, RedeemedVoucher>> redeemVoucher(
    String voucher,
  ) async {
    final result = await executor(
      () => apiV1.apiV1PurchasesRedeemvoucherPost(voucherCode: voucher),
    );

    return result.map(RedeemedVoucher.fromDTO);
  }
}

import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/extensions/either_extensions.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/voucher/data/models/redeemed_voucher_model.dart';
import 'package:coffeecard/features/voucher/domain/entities/redeemed_voucher.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:fpdart/fpdart.dart';

class VoucherRemoteDataSource {
  final CoffeecardApi apiV1;
  final NetworkRequestExecutor executor;

  VoucherRemoteDataSource({
    required this.apiV1,
    required this.executor,
  });

  Future<Either<NetworkFailure, RedeemedVoucher>> redeemVoucher(
    String voucher,
  ) async {
    return executor(
      () => apiV1.apiV1PurchasesRedeemvoucherPost(voucherCode: voucher),
    ).bindFuture(RedeemedVoucherModel.fromDTO);
  }
}

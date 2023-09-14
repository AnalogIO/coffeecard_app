import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/voucher/data/models/redeemed_voucher_model.dart';
import 'package:coffeecard/features/voucher/domain/entities/redeemed_voucher.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:fpdart/fpdart.dart';

class VoucherRemoteDataSource {
  final CoffeecardApiV2 api;
  final NetworkRequestExecutor executor;

  VoucherRemoteDataSource({
    required this.api,
    required this.executor,
  });

  Future<Either<NetworkFailure, RedeemedVoucher>> redeemVoucher(
    String voucher,
  ) async {
    return executor
        .execute(
          () => api.apiV2VouchersVoucherCodeRedeemPost(voucherCode: voucher),
        )
        .map(RedeemedVoucherModel.fromDTO);
  }
}

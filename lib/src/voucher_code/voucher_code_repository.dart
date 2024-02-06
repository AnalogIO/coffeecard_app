import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/voucher_code.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:fpdart/fpdart.dart';

class VoucherCodeRepository {
  const VoucherCodeRepository({
    required this.api,
    required this.executor,
  });

  final CoffeecardApiV2 api;
  final NetworkRequestExecutor executor;

  TaskEither<Failure, RedeemedVoucher> redeemVoucherCode(String voucher) {
    return executor
        .executeAsTask(
          () => api.apiV2VouchersVoucherCodeRedeemPost(voucherCode: voucher),
        )
        .map(RedeemedVoucher.fromDTO);
  }
}

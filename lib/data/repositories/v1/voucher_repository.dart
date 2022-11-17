import 'package:coffeecard/data/repositories/utils/executor.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/models/voucher/redeemed_voucher.dart';
import 'package:coffeecard/utils/either.dart';

class VoucherRepository {
  VoucherRepository({
    required this.apiV1,
    required this.executor,
  });

  final CoffeecardApi apiV1;
  final Executor executor;

  Future<Either<RequestError, RedeemedVoucher>> redeemVoucher(
    String voucher,
  ) async {
    return executor.execute(
      () => apiV1.apiV1PurchasesRedeemvoucherPost(voucherCode: voucher),
      RedeemedVoucher.fromDTO,
    );
  }
}

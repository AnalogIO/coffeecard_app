import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/models/voucher/redeemed_voucher.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/utils/extensions.dart';
import 'package:logger/logger.dart';

class VoucherRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  VoucherRepository(this._api, this._logger);

  Future<Either<ApiError, RedeemedVoucher>> redeemVoucher(
    String voucher,
  ) async {
    final response = await _api.apiV1PurchasesRedeemvoucherPost(
      voucherCode: voucher,
    );

    if (response.isSuccessful) {
      final body = response.body!;
      final redeemedVoucher = RedeemedVoucher(
        numberOfTickets: body.numberOfTickets,
        productName: body.productName,
      );
      return Right(redeemedVoucher);
    } else if (response.statusCode == 404) {
      _logger.e(response.formatError());
      return Left(ApiError(Strings.invalidVoucher(voucher)));
    } else if (response.statusCode == 400) {
      return const Left(ApiError(Strings.voucherUsed));
    } else {
      return Left(ApiError(response.error.toString()));
    }
  }
}

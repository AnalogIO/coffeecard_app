import 'package:chopper/chopper.dart';
import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/errors/request_error.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/models/voucher/redeemed_voucher.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/utils/extensions.dart';
import 'package:logger/logger.dart';

class VoucherRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  VoucherRepository(this._api, this._logger);

  Future<Either<RequestError, RedeemedVoucher>> redeemVoucher(
    String voucher,
  ) async {
    final Response<PurchaseDto> response;
    try {
      response = await _api.apiV1PurchasesRedeemvoucherPost(
        voucherCode: voucher,
      );
    } catch (e) {
      return Left(ClientNetworkError());
    }

    if (response.isSuccessful) {
      final body = response.body!;
      final redeemedVoucher = RedeemedVoucher(
        numberOfTickets: body.numberOfTickets,
        productName: body.productName,
      );
      return Right(redeemedVoucher);
    }
    _logger.e(response.formatError());
    if (response.statusCode == 404) {
      return Left(RequestError(Strings.invalidVoucher(voucher), 404));
    }
    if (response.statusCode == 400) {
      return const Left(RequestError(Strings.voucherUsed, 400));
    }
    return Left(RequestError(response.error.toString(), response.statusCode));
  }
}

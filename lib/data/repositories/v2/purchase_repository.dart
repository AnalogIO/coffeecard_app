import 'package:chopper/chopper.dart';
import 'package:coffeecard/data/repositories/utils/executor.dart';
import 'package:coffeecard/errors/request_error.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/utils/extensions.dart';
import 'package:logger/logger.dart';

class PurchaseRepository {
  final CoffeecardApiV2 _api;
  final Logger _logger;

  PurchaseRepository(this._api, this._logger);

  /// Initiate a new Purchase Request. The return is a purchase request
  /// with payment details on how to pay for the purchase
  Future<Either<RequestError, InitiatePurchaseResponse>> initiatePurchase(
    int productId,
    PaymentType paymentType,
  ) async {
    return Executor.executeNetworkRequestSafely(
      () => _api.apiV2PurchasesPost(
        body: InitiatePurchaseRequest(
          productId: productId,
          paymentType: paymentType,
        ),
      ),
      _logger,
    );
  }

  /// Get a purchase by its purchase id
  Future<Either<RequestError, SinglePurchaseResponse>> getPurchase(
    int purchaseId,
  ) async {
    return Executor.executeNetworkRequestSafely(
      () => _api.apiV2PurchasesIdGet(id: purchaseId),
      _logger,
    );
  }
}

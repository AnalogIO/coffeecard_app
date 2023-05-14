import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/purchase/initiate_purchase.dart';
import 'package:coffeecard/models/purchase/single_purchase.dart';
import 'package:fpdart/fpdart.dart';

class PurchaseRepository {
  PurchaseRepository({
    required this.apiV2,
    required this.executor,
  });

  final CoffeecardApiV2 apiV2;
  final NetworkRequestExecutor executor;

  /// Initiate a new Purchase Request. The return is a purchase request
  /// with payment details on how to pay for the purchase
  Future<Either<NetworkFailure, InitiatePurchase>> initiatePurchase(
    int productId,
    PaymentType paymentType,
  ) async {
    final result = await executor(
      () => apiV2.apiV2PurchasesPost(
        body: InitiatePurchaseRequest(
          productId: productId,
          paymentType: paymentTypeToJson(paymentType),
        ),
      ),
    );

    return result.map(InitiatePurchase.fromDto);
  }

  /// Get a purchase by its purchase id
  Future<Either<NetworkFailure, SinglePurchase>> getPurchase(
    int purchaseId,
  ) async {
    final result = await executor(
      () => apiV2.apiV2PurchasesIdGet(id: purchaseId),
    );

    return result.map(SinglePurchase.fromDto);
  }
}

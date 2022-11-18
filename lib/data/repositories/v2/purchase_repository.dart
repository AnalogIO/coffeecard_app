import 'package:coffeecard/data/repositories/utils/executor.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/utils/either.dart';

class PurchaseRepository {
  PurchaseRepository({
    required this.apiV2,
    required this.executor,
  });

  final CoffeecardApiV2 apiV2;
  final Executor executor;

  /// Initiate a new Purchase Request. The return is a purchase request
  /// with payment details on how to pay for the purchase
  Future<Either<RequestFailure, InitiatePurchaseResponse>> initiatePurchase(
    int productId,
    PaymentType paymentType,
  ) async {
    return executor.execute(
      () => apiV2.apiV2PurchasesPost(
        body: InitiatePurchaseRequest(
          productId: productId,
          paymentType: paymentType,
        ),
      ),
      // FIXME: No generated code as return type!
      (dto) => dto,
    );
  }

  /// Get a purchase by its purchase id
  Future<Either<RequestFailure, SinglePurchaseResponse>> getPurchase(
    int purchaseId,
  ) async {
    return executor.execute(
      () => apiV2.apiV2PurchasesIdGet(id: purchaseId),
      // FIXME: No generated code as return type!
      (dto) => dto,
    );
  }
}

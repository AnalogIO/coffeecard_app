import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/purchase/data/models/initiate_purchase_model.dart';
import 'package:coffeecard/features/purchase/data/models/single_purchase_model.dart';
import 'package:coffeecard/features/purchase/domain/entities/initiate_purchase.dart';
import 'package:coffeecard/features/purchase/domain/entities/single_purchase.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:fpdart/fpdart.dart';

class PurchaseRemoteDataSource {
  PurchaseRemoteDataSource({
    required this.apiV2,
    required this.executor,
  });

  final CoffeecardApiV2 apiV2;
  final NetworkRequestExecutor executor;

  /// Initiate a new Purchase Request. The return is a purchase request
  /// with payment details on how to pay for the purchase
  Future<Either<Failure, InitiatePurchase>> initiatePurchase(
    int productId,
    PaymentType paymentType,
  ) {
    return executor
        .execute(
          () => apiV2.apiV2PurchasesPost(
            body: InitiatePurchaseRequest(
              productId: productId,
              paymentType: paymentTypeToJson(paymentType),
            ),
          ),
        )
        .map(InitiatePurchaseModel.fromDto);
  }

  /// Get a purchase by its purchase id
  Future<Either<Failure, SinglePurchase>> getPurchase(int purchaseId) {
    return executor
        .execute(() => apiV2.apiV2PurchasesIdGet(id: purchaseId))
        .map(SinglePurchaseModel.fromDto);
  }
}

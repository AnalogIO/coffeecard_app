import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/extensions/either_extensions.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/purchase/data/models/payment_model.dart';
import 'package:coffeecard/features/purchase/data/models/payment_type.dart';
import 'package:coffeecard/features/purchase/data/models/single_purchase_model.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:coffeecard/features/purchase/domain/entities/single_purchase.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart'
    as swagger;
import 'package:fpdart/fpdart.dart';

class PurchaseRemoteDataSource {
  PurchaseRemoteDataSource({
    required this.apiV2,
    required this.executor,
  });

  final swagger.CoffeecardApiV2 apiV2;
  final NetworkRequestExecutor executor;

  /// Initiate a new Purchase Request. The return is a purchase request
  /// with payment details on how to pay for the purchase
  Future<Either<NetworkFailure, Payment>> initiatePurchase(
    int productId,
    PaymentType paymentType,
  ) async {
    return executor(
      () => apiV2.apiV2PurchasesPost(
        body: swagger.InitiatePurchaseRequest(
          productId: productId,
          paymentType: swagger.paymentTypeToJson(paymentType.swaggerEnum),
        ),
      ),
    ).bindFuture((dto) => PaymentModel.fromDto(dto, paymentType));
  }

  /// Get a purchase by its purchase id
  Future<Either<NetworkFailure, SinglePurchase>> getPurchase(
    int purchaseId,
  ) async {
    return executor(
      () => apiV2.apiV2PurchasesIdGet(id: purchaseId),
    ).bindFuture(SinglePurchaseModel.fromDto);
  }
}

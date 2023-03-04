import 'package:coffeecard/core/errors/exceptions.dart';
import 'package:coffeecard/core/network/executor.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/purchase/initiate_purchase.dart';
import 'package:coffeecard/models/purchase/single_purchase.dart';
import 'package:dartz/dartz.dart';

class PurchaseRepository {
  PurchaseRepository({
    required this.apiV2,
    required this.executor,
  });

  final CoffeecardApiV2 apiV2;
  final Executor executor;

  /// Initiate a new Purchase Request. The return is a purchase request
  /// with payment details on how to pay for the purchase
  Future<Either<RequestFailure, InitiatePurchase>> initiatePurchase(
    int productId,
    PaymentType paymentType,
  ) async {
    try {
      final result = await executor(
        () => apiV2.apiV2PurchasesPost(
          body: InitiatePurchaseRequest(
            productId: productId,
            paymentType: paymentTypeToJson(paymentType),
          ),
        ),
      );

      return Right(InitiatePurchase.fromDto(result!));
    } on ServerException catch (e) {
      return Left(RequestFailure(e.error));
    }
  }

  /// Get a purchase by its purchase id
  Future<Either<RequestFailure, SinglePurchase>> getPurchase(
    int purchaseId,
  ) async {
    try {
      final result = await executor(
        () => apiV2.apiV2PurchasesIdGet(id: purchaseId),
      );

      return Right(SinglePurchase.fromDto(result!));
    } on ServerException catch (e) {
      return Left(RequestFailure(e.error));
    }
  }
}

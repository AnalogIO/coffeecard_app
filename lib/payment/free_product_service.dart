import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.enums.swagger.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:dartz/dartz.dart';

class FreeProductService extends PaymentHandler {
  final PurchaseRepository _repository;

  const FreeProductService({
    required super.repository,
    required super.context,
  }) : _repository = repository;

  @override
  Future<Either<Failure, Payment>> initPurchase(int productId) async {
    final response =
        await _repository.initiatePurchase(productId, PaymentType.freepurchase);

    return response.fold(
      (l) => Left(l),
      (r) => Right(
        Payment(
          id: r.id,
          status: PaymentStatus.completed,
          deeplink: '',
          purchaseTime: r.dateCreated,
          price: r.totalAmount,
          productId: r.productId,
          productName: r.productName,
        ),
      ),
    );
  }
}

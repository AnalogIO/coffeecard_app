import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/data/repositories/v2/purchase_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.enums.swagger.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';

class FreeProductService extends PaymentHandler {
  final PurchaseRepository _repository;
  final BuildContext _context;

  const FreeProductService({
    required super.repository,
    required super.context,
  })  : _repository = repository,
        _context = context;

  @override
  Future<Either<RequestFailure, Payment>> initPurchase(int productId) async {
    final response =
        await _repository.initiatePurchase(productId, PaymentType.freepurchase);

    return response.fold((l) => Left(l), (r) => Right(
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

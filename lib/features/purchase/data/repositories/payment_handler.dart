import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/extensions/either_extensions.dart';
import 'package:coffeecard/features/purchase/data/datasources/purchase_remote_data_source.dart';
import 'package:coffeecard/features/purchase/data/repositories/free_product_service.dart';
import 'package:coffeecard/features/purchase/data/repositories/mobilepay_service.dart';
import 'package:coffeecard/features/purchase/domain/entities/internal_payment_type.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';

abstract class PaymentHandler {
  final PurchaseRemoteDataSource purchaseRemoteDataSource;
  final BuildContext context;

  const PaymentHandler({
    required this.purchaseRemoteDataSource,
    required this.context,
  });

  Future<Either<Failure, Payment>> initPurchase(int productId);

  static PaymentHandler createPaymentHandler(
    InternalPaymentType paymentType,
    BuildContext context,
  ) {
    final repository = sl.get<PurchaseRemoteDataSource>();

    return switch (paymentType) {
      InternalPaymentType.mobilePay => MobilePayService(
          purchaseRemoteDataSource: repository,
          context: context,
        ),
      InternalPaymentType.free => FreeProductService(
          purchaseRemoteDataSource: repository,
          context: context,
        ),
    };
  }

  Future<Either<Failure, PaymentStatus>> verifyPurchase(
    int purchaseId,
  ) async {
    // Call API endpoint, receive PaymentStatus
    return purchaseRemoteDataSource
        .getPurchase(purchaseId)
        .bindFuture((purchase) => purchase.status);
  }
}

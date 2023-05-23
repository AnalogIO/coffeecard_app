import 'package:coffeecard/features/purchase/domain/entities/initiate_purchase.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';

class InitiatePurchaseModel extends InitiatePurchase {
  const InitiatePurchaseModel({
    required super.id,
    required super.totalAmount,
    required super.paymentDetails,
    required super.productId,
    required super.productName,
    required super.purchaseStatus,
    required super.dateCreated,
  });

  factory InitiatePurchaseModel.fromDto(InitiatePurchaseResponse dto) {
    return InitiatePurchaseModel(
      id: dto.id,
      totalAmount: dto.totalAmount,
      paymentDetails: MobilePayPaymentDetails.fromJsonFactory(
        dto.paymentDetails as Map<String, dynamic>,
      ),
      productId: dto.productId,
      productName: dto.productName,
      purchaseStatus: dto.purchaseStatus as String,
      dateCreated: dto.dateCreated,
    );
  }
}

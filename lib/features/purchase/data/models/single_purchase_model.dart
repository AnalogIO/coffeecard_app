import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:coffeecard/features/purchase/domain/entities/single_purchase.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';

class SinglePurchaseModel extends SinglePurchase {
  SinglePurchaseModel({
    required super.id,
    required super.totalAmount,
    required super.paymentDetails,
    required super.status,
    required super.dateCreated,
  });

  factory SinglePurchaseModel.fromDto(SinglePurchaseResponse dto) {
    return SinglePurchaseModel(
      id: dto.id,
      totalAmount: dto.totalAmount,
      paymentDetails: dto.paymentDetails as Map<String, dynamic>,
      status: PaymentStatus.fromPurchaseStatus(
        purchaseStatusFromJson(dto.purchaseStatus),
      ),
      dateCreated: dto.dateCreated,
    );
  }
}

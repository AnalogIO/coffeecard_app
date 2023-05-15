import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.models.swagger.dart';

class PurchaseReceiptModel extends PurchaseReceipt {
  const PurchaseReceiptModel({
    required super.productName,
    required super.timeUsed,
    required super.id,
    required super.price,
    required super.amountPurchased,
  });

  /// Creates a receipt from a purchase DTO
  factory PurchaseReceiptModel.fromSimplePurchaseResponse(
    SimplePurchaseResponse dto,
  ) {
    return PurchaseReceiptModel(
      productName: dto.productName,
      timeUsed: dto.dateCreated,
      price: dto.totalAmount,
      amountPurchased: dto.numberOfTickets,
      id: dto.id,
    );
  }
}

import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';

class InitiatePurchase {
  final int id;
  final int totalAmount;
  final Map<String, String> paymentDetails;
  final int productId;
  final String productName;
  final String purchaseStatus;
  final DateTime dateCreated;

  const InitiatePurchase({
    required this.id,
    required this.totalAmount,
    required this.paymentDetails,
    required this.productId,
    required this.productName,
    required this.purchaseStatus,
    required this.dateCreated,
  });

  InitiatePurchase.fromDto(InitiatePurchaseResponse dto)
      : id = dto.id,
        totalAmount = dto.totalAmount,
        paymentDetails = dto.paymentDetails as Map<String, String>,
        productId = dto.productId,
        productName = dto.productName,
        purchaseStatus = dto.purchaseStatus as String,
        dateCreated = dto.dateCreated;
}

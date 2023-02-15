import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';

class SinglePurchase {
  final int id;
  final int totalAmount;
  final Map<String, dynamic> paymentDetails;
  final String purchaseStatus;
  final DateTime dateCreated;

  const SinglePurchase({
    required this.id,
    required this.totalAmount,
    required this.paymentDetails,
    required this.purchaseStatus,
    required this.dateCreated,
  });

  SinglePurchase.fromDto(SinglePurchaseResponse dto)
      : id = dto.id,
        totalAmount = dto.totalAmount,
        paymentDetails = dto.paymentDetails as Map<String, dynamic>,
        purchaseStatus = dto.purchaseStatus as String,
        dateCreated = dto.dateCreated;
}

import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';

class InitiatePurchase {
  final int id;
  final int totalAmount;
  final MobilePayPaymentDetails paymentDetails;
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
}

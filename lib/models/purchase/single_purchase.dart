import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';

class SinglePurchase {
  final int id;
  final int totalAmount;
  final Map<String, dynamic> paymentDetails;
  final PaymentStatus status;
  final DateTime dateCreated;

  const SinglePurchase({
    required this.id,
    required this.totalAmount,
    required this.paymentDetails,
    required this.status,
    required this.dateCreated,
  });

  SinglePurchase.fromDto(SinglePurchaseResponse dto)
      : id = dto.id,
        totalAmount = dto.totalAmount,
        paymentDetails = dto.paymentDetails as Map<String, dynamic>,
        status = PaymentStatus.fromPurchaseStatus(
          purchaseStatusFromJson(dto.purchaseStatus),
        ),
        dateCreated = dto.dateCreated;
}

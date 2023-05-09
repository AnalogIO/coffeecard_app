import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';

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
}

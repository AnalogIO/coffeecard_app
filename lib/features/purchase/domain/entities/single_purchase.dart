import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:equatable/equatable.dart';

class SinglePurchase extends Equatable {
  final int id;
  final int totalAmount;
  final PaymentStatus status;
  final DateTime dateCreated;

  const SinglePurchase({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.dateCreated,
  });

  @override
  List<Object?> get props => [
        id,
        totalAmount,
        status,
        dateCreated,
      ];
}

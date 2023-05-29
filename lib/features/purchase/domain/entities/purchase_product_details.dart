import 'package:equatable/equatable.dart';

/// Represents the details of a product within a purchase.
class PurchaseProductDetails extends Equatable {
  const PurchaseProductDetails({
    required this.id,
    required this.totalAmount,
    required this.productId,
    required this.productName,
    required this.purchaseStatus,
    required this.dateCreated,
  });

  final int id;
  final int totalAmount;
  final int productId;
  final String productName;
  final String purchaseStatus;
  final DateTime dateCreated;

  @override
  List<Object?> get props => [
        id,
        totalAmount,
        productId,
        productName,
        purchaseStatus,
        dateCreated,
      ];
}

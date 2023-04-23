import 'package:equatable/equatable.dart';

enum TransactionType { purchase, ticketSwipe, placeholder }

/// A receipt for either a used ticket, or a purchase
class Receipt extends Equatable {
  final String productName;
  final TransactionType transactionType;
  final DateTime timeUsed;
  final int price;
  final int amountPurchased;
  final int id;

  const Receipt({
    required this.productName,
    required this.transactionType,
    required this.timeUsed,
    required this.price,
    required this.amountPurchased,
    required this.id,
  });

  bool get isPurchase => transactionType == TransactionType.purchase;

  @override
  List<Object?> get props =>
      [productName, transactionType, timeUsed, price, amountPurchased, id];
}

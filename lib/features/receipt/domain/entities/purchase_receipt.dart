import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';

class PurchaseReceipt extends Receipt {
  final int price;
  final int amountPurchased;

  const PurchaseReceipt({
    required super.productName,
    required super.timeUsed,
    required super.id,
    required this.price,
    required this.amountPurchased,
  });
}

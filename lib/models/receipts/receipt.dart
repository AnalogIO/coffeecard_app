enum TransactionType { purchase, ticketSwipe, placeholder }

/// A receipt for either a used ticket, or a purchase
class Receipt {
  final String productName;
  final TransactionType transactionType;
  final DateTime timeUsed;
  final int price;
  final int amountPurchased;
  final int id;

  Receipt({
    required this.productName,
    required this.transactionType,
    required this.timeUsed,
    required this.price,
    required this.amountPurchased,
    required this.id,
  });

  @override
  String toString() {
    return 'Receipt{productName: $productName, transactionType: $transactionType, timeUsed: $timeUsed, price: $price, amountPurchased: $amountPurchased, id: $id}';
  }
}

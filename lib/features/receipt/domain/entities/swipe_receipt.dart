import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';

class SwipeReceipt extends Receipt {
  const SwipeReceipt({
    required super.productName,
    required super.transactionType,
    required super.timeUsed,
    required super.id,
  });
}

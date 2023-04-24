import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';

class PlaceholderReceipt extends Receipt {
  PlaceholderReceipt()
      : super(
          productName: Strings.receiptPlaceholderName,
          timeUsed: DateTime.now(),
          id: -1,
        );
}

part of 'receipt.dart';

class PlaceholderReceipt extends Receipt {
  PlaceholderReceipt()
      : super(
          productName: Strings.receiptPlaceholderName,
          timeUsed: DateTime.now(),
          id: -1,
        );
}

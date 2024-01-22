part of 'receipt.dart';

/// A receipt for a ticket that has been used
class SwipeReceipt extends Receipt {
  /// The menu item that the ticket was used for
  final String menuItemName;

  const SwipeReceipt({
    required super.productName,
    required super.timeUsed,
    required super.id,
    required this.menuItemName,
  });
}

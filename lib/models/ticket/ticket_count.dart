const _baristaProductIds = [9, 11, 12, 13];

class TicketCount {
  final int productId;
  final int count;
  final String productName;

  TicketCount({
    required this.count,
    required this.productName,
    required this.productId,
  });

  bool isBaristaTicket() {
    return _baristaProductIds.contains(productId);
  }

  @override
  String toString() {
    return 'ProductCount{count: $count, productName: $productName}';
  }
}

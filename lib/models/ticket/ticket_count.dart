class TicketCount {
  final int productId;
  final int count;
  final String productName;
  final bool isBaristaTicket;

  TicketCount({
    required this.count,
    required this.productName,
    required this.productId,
    required this.isBaristaTicket,
  });

  @override
  String toString() {
    return 'ProductCount{count: $count, productName: $productName}';
  }
}

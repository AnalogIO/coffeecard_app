class TicketCount {
  final int productId;
  final int count;
  final String productName;

  TicketCount({required this.count, required this.productName, required this.productId});

  @override
  String toString() {
    return 'ProductCount{count: $count, productName: $productName}';
  }
}

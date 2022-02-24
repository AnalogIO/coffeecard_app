class ProductCount {
  final int count;
  final String productName;

  ProductCount(this.count, this.productName);

  @override
  String toString() {
    return 'ProductCount{count: $count, productName: $productName}';
  }
}

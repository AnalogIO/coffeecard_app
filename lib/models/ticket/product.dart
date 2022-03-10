class Product {
  final int id;
  final int amount;
  final int price;
  final String productName;

  Product({
    required this.price,
    required this.amount,
    required this.productName,
    required this.id,
  });

  @override
  String toString() {
    return 'Product{id: $id, amount: $amount, price: $price, productName: $productName}';
  }
}

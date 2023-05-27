class Product {
  final int id;
  final int amount;
  final int price;
  final String name;
  final String description;

  const Product({
    required this.price,
    required this.amount,
    required this.name,
    required this.id,
    required this.description,
  });

  @override
  String toString() {
    return 'Product{id: $id, amount: $amount, price: $price, productName: $name, description> $description}';
  }
}

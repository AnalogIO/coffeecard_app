import 'package:coffeecard/generated/api/coffeecard_api.swagger.models.swagger.dart';

class Product {
  final int id;
  final int amount;
  final int price;
  final String productName;
  final String? description;

  Product({
    required this.price,
    required this.amount,
    required this.productName,
    required this.id,
    this.description,
  });

  Product.fromDTO(ProductDto dto)
      : id = dto.id!,
        productName = dto.name!,
        price = dto.price!,
        amount = dto.numberOfTickets!,
        description = dto.description!;

  @override
  String toString() {
    return 'Product{id: $id, amount: $amount, price: $price, productName: $productName, description> $description}';
  }
}

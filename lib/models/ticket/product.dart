import 'package:coffeecard/generated/api/coffeecard_api.swagger.models.swagger.dart';

class Product {
  final int id;
  final int amount;
  final int price;
  final String name;
  final String description;

  Product({
    required this.price,
    required this.amount,
    required this.name,
    required this.id,
    required this.description,
  });

  Product.fromDTO(ProductDto dto)
      : id = dto.id!,
        name = dto.name!,
        price = dto.price!,
        amount = dto.numberOfTickets!,
        description = dto.description!;

  @override
  String toString() {
    return 'Product{id: $id, amount: $amount, price: $price, productName: $name, description> $description}';
  }
}

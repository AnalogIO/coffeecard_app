import 'package:coffeecard/features/product/domain/entities/product.dart';
import 'package:coffeecard/generated/api/coffeecard_api.models.swagger.dart';

class ProductModel extends Product {
  ProductModel({
    required super.price,
    required super.amount,
    required super.name,
    required super.id,
    required super.description,
  });

  factory ProductModel.fromDTO(ProductDto dto) {
    return ProductModel(
      price: dto.price,
      amount: dto.numberOfTickets,
      name: dto.name,
      id: dto.id,
      description: dto.description,
    );
  }
}

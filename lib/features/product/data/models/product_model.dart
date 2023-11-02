import 'package:coffeecard/features/product/domain/entities/product.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.models.swagger.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.price,
    required super.amount,
    required super.name,
    required super.id,
    required super.description,
    required super.isPerk,
  });

  factory ProductModel.fromResponse(ProductResponse response) {
    return ProductModel(
      price: response.price,
      amount: response.numberOfTickets,
      name: response.name,
      id: response.id,
      description: response.description,
      isPerk: response.isPerk,
    );
  }
}

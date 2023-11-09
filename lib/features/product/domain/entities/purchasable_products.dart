import 'package:coffeecard/features/product/domain/entities/product.dart';

typedef PurchasableProducts = ({
  Iterable<Product> clipCards,
  Iterable<Product> singleDrinks,
  Iterable<Product> perks,
});

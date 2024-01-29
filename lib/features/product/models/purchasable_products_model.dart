import 'package:coffeecard/features/product/product.dart';

typedef PurchasableProducts = ({
  Iterable<Product> clipCards,
  Iterable<Product> singleDrinks,
  Iterable<Product> perks,
});

extension PurchasableProductsExtension on PurchasableProducts {
  Iterable<Product> get all => [
        ...clipCards,
        ...singleDrinks,
        ...perks,
      ];
}

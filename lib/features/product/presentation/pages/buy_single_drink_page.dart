import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/features/product/presentation/pages/buy_products_page.dart';
import 'package:coffeecard/features/product/purchasable_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuySingleDrinkPage extends StatelessWidget {
  /// Formerly a page used for buying a single drink, now used to buy merch.
  const BuySingleDrinkPage();

  static Route get route =>
      MaterialPageRoute(builder: (_) => const BuySingleDrinkPage());

  @override
  Widget build(BuildContext context) {
    return BuyProductsPage(
      title: Strings.buyOneDrinkPageTitle,
      products: context.watch<PurchasableProducts>().singleDrinks,
    );
  }
}

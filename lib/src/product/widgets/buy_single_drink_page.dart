import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/features/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuySingleDrinkPage extends StatelessWidget {
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

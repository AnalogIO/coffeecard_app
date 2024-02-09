import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/features/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyTicketsPage extends StatelessWidget {
  const BuyTicketsPage();

  static Route get route =>
      MaterialPageRoute(builder: (_) => const BuyTicketsPage());

  @override
  Widget build(BuildContext context) {
    return BuyProductsPage(
      title: Strings.buyTickets,
      products: context.watch<PurchasableProducts>().clipCards,
    );
  }
}

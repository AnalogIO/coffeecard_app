import 'package:coffeecard/core/widgets/components/scaffold.dart';
import 'package:coffeecard/features/product/presentation/widgets/buy_tickets_card.dart';
import 'package:coffeecard/features/product/product_model.dart';
import 'package:flutter/material.dart';

/// Generic page for buying products.
///
/// Used for both [BuyTicketsPage] and [BuySingleDrinkPage].
class BuyProductsPage extends StatelessWidget {
  const BuyProductsPage({required this.title, required this.products});

  final String title;
  final Iterable<Product> products;

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: title,
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(
          16,
          8,
          16,
          16 + MediaQuery.paddingOf(context).bottom,
        ),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) => BuyTicketsCard(products.elementAt(index)),
      ),
    );
  }
}

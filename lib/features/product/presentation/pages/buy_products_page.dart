import 'package:coffeecard/core/widgets/components/helpers/grid.dart';
import 'package:coffeecard/core/widgets/components/scaffold.dart';
import 'package:coffeecard/features/product/domain/entities/product.dart';
import 'package:coffeecard/features/product/presentation/widgets/buy_tickets_card.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Grid(
          gap: GridGap.normal,
          gapSmall: GridGap.tight,
          singleColumnOnSmallDevice: true,
          children: products.map(BuyTicketsCard.new).toList(),
        ),
      ),
    );
  }
}

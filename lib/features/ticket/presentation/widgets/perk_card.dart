import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/features/product/domain/entities/product.dart';
import 'package:coffeecard/features/product/presentation/functions.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/shop_card.dart';
import 'package:flutter/material.dart';

class PerkCard extends StatelessWidget {
  PerkCard._({required this.title, required this.product, required int price})
      : price = switch (price) {
          0 => Strings.free,
          final price => Strings.price(price),
        };

  PerkCard.fromProduct(Product product)
      : this._(
          title: product.name,
          product: product,
          price: product.price,
        );

  final String title;
  final Product product;
  final String price;

  @override
  Widget build(BuildContext context) {
    return ShopCard(
      title: title,
      icon: Icons.coffee_maker_outlined,
      onTapped: (_) => buyModal(
        context: context,
        product: product,
        callback: (_, __) => Future.value(),
      ),
      optionalText: price,
    );
  }
}

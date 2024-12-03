import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/dialog.dart';
import 'package:coffeecard/features/product/presentation/functions.dart';
import 'package:coffeecard/features/product/product_model.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/shop_card.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/swipe_ticket_confirm.dart';
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

  void _onTapped(BuildContext context) {
    if (product.price == 0 && product.amount == 1) {
      showClaimSinglePerkConfirm(
        context: context,
        product: product,
      );
    } else if (product.price == 0 && product.amount > 1) {
      appDialog(
        context: context,
        title: 'Oops!',
        children: [
          Text(
            'This free product would grant ${product.amount} tickets. '
            'You cannot claim a free product that would grant multiple tickets.',
          ),
        ],
        actions: [
          TextButton(
            onPressed: () => closeAppDialog(context),
            child: const Text('OK'),
          ),
        ],
        dismissible: true,
      );
    } else {
      buyModal(
        context: context,
        product: product,
        callback: (_, __) async {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'perk_${product.id}',
      child: ShopCard(
        title: title,
        // TODO(fredpetersen): Get icon from product
        icon: Icons.coffee_maker_outlined,
        onTapped: _onTapped,
        optionalText: price,
      ),
    );
  }
}

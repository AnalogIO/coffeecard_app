import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/card.dart';
import 'package:coffeecard/core/widgets/components/helpers/responsive.dart';
import 'package:coffeecard/features/product/domain/entities/product.dart';
import 'package:coffeecard/features/product/presentation/functions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BuyTicketsCard extends StatefulWidget {
  final Product product;

  const BuyTicketsCard(this.product);

  @override
  State<BuyTicketsCard> createState() => _BuyTicketsCardState();
}

class _BuyTicketsCardState extends State<BuyTicketsCard> {
  Future<void> onTap(BuildContext context, Product product) {
    return buyModal(
      context: context,
      product: product,
      callback: (context, _) async => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CardBase(
      color: AppColors.white,
      gap: deviceIsSmall(context) ? 48 : 64,
      top: CardTitle(
        title: Text(widget.product.name, style: AppTextStyle.ownedTicket),
        description:
            Text(widget.product.description, style: AppTextStyle.explainer),
      ),
      bottom: CardBottomRow(
        left: _TicketPrice(
          amount: widget.product.amount,
          price: widget.product.price,
        ),
      ),
      onTap: (context) => onTap(context, widget.product),
    );
  }
}

class _TicketPrice extends StatelessWidget {
  const _TicketPrice({required this.amount, required this.price});

  final int amount;
  final int price;

  String get _amountDisplayName {
    final s = amount != 1 ? 's' : '';
    return '$amount ticket$s';
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: deviceIsSmall(context) ? Axis.horizontal : Axis.vertical,
      verticalDirection: deviceIsSmall(context)
          ? VerticalDirection.down
          : VerticalDirection.up,
      crossAxisAlignment: deviceIsSmall(context)
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.stretch,
      children: [
        Text('$price,-', style: AppTextStyle.sectionTitle),
        if (deviceIsSmall(context)) const Gap(8),
        Text(_amountDisplayName, style: AppTextStyle.explainerDark),
      ],
    );
  }
}

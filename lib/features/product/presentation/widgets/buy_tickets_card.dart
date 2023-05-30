import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/features/product/domain/entities/product.dart';
import 'package:coffeecard/utils/responsive.dart';
import 'package:coffeecard/widgets/components/card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BuyTicketsCard extends StatefulWidget {
  final Product product;
  final void Function(BuildContext, Product, State) onTap;

  const BuyTicketsCard({required this.product, required this.onTap});

  @override
  State<BuyTicketsCard> createState() => _BuyTicketsCardState();
}

class _BuyTicketsCardState extends State<BuyTicketsCard> {
  @override
  Widget build(BuildContext context) {
    return CardBase(
      color: AppColor.white,
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
      onTap: (context) => widget.onTap(context, widget.product, this),
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

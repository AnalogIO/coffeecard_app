import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/utils/responsive.dart';
import 'package:coffeecard/widgets/components/card.dart';
import 'package:coffeecard/widgets/components/tickets/buy_ticket_bottom_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BuyTicketsCard extends CardBase {
  final Product product;

  BuyTicketsCard({Key? key, required this.product})
      : super(
          key: key,
          color: AppColor.white,
          gap: 64, // FIXME: Should be 48 for small devices
          top: CardTitle(
            title: Text(product.productName, style: AppTextStyle.ownedTicket),
            description:
                Text(product.description ?? '', style: AppTextStyle.explainer),
          ),
          bottom: CardBottomRow(
            left: _TicketPrice(amount: product.amount, price: product.price),
          ),
          onTap: (context) {
            showModalBottomSheet(
              context: context,
              barrierColor: AppColor.scrim,
              backgroundColor: Colors.transparent,
              isDismissible: true,
              useRootNavigator: true,
              builder: (_) => BuyTicketBottomModalSheet(product: product),
            );
          },
        );
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

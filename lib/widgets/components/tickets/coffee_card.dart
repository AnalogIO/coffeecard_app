import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/card.dart';
import 'package:coffeecard/widgets/components/tickets/swipe_overlay.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CoffeeCard extends CardBase {
  final String title;
  final int amountOwned;
  final int productId;

  CoffeeCard({Key? key, required this.title, required this.amountOwned, required this.productId})
      : super(
          key: key,
          color: AppColor.ticket,
          top: CardTitle(
            title: Text(title, style: AppTextStyle.ownedTicket),
          ),
          bottom: CardBottomRow(
            left: _TicketDots(amountOwned: amountOwned),
            right: _TicketAmountText(amountOwned: amountOwned),
          ),
          gap: 36,
          onTap: (context) {
            showModalBottomSheet(
              enableDrag: false,
              context: context,
              builder: (builder) {
                return SwipeOverlay(
                  title: title,
                  productId: productId,
                );
              },
            );
          },
        );
}

class _TicketDots extends StatelessWidget {
  const _TicketDots({required this.amountOwned});

  final int amountOwned;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: 86,
          height: 30,
          margin: const EdgeInsets.only(bottom: 1),
          child: Wrap(
            verticalDirection: VerticalDirection.up,
            spacing: 4,
            runSpacing: 2,
            children: List.generate(10, (index) {
              return Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: (amountOwned > index) ? AppColor.secondary : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColor.primary, width: 2),
                ),
              );
            }),
          ),
        ),
        const Gap(8),
        if (amountOwned > 10) Text('+${amountOwned - 10}', style: AppTextStyle.ticketsOverflow)
      ],
    );
  }
}

class _TicketAmountText extends StatelessWidget {
  const _TicketAmountText({required this.amountOwned});

  final int amountOwned;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Tickets left',
        style: AppTextStyle.textField,
        children: [
          const WidgetSpan(child: SizedBox(width: 8)),
          TextSpan(text: '$amountOwned', style: AppTextStyle.ownedTicket),
        ],
      ),
    );
  }
}

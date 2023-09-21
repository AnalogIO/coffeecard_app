import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/swipe_ticket_confirm.dart';
import 'package:coffeecard/widgets/components/card.dart';
import 'package:flutter/material.dart';

class CoffeeCard extends StatelessWidget {
  final String title;
  final int amountOwned;
  final int productId;

  const CoffeeCard({
    required this.title,
    required this.amountOwned,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return CardBase(
      color: AppColors.ticket,
      top: CardTitle(
        title: Text(title, style: AppTextStyle.ownedTicket),
      ),
      bottom: CardBottomRow(
        left: _TicketDots(amountOwned: amountOwned),
        right: _TicketAmountText(amountOwned: amountOwned),
      ),
      gap: 36,
      onTap: (context) {
        final _ = showSwipeTicketConfirm(
          context: context,
          productName: title,
          amountOwned: amountOwned,
          productId: productId,
        );
      },
    );
  }
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
                  color: (amountOwned > index)
                      ? AppColors.secondary
                      : Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  border: const Border.fromBorderSide(
                    BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              );
            }),
          ),
        ),
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

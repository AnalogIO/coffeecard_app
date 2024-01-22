import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/card.dart';
import 'package:coffeecard/core/widgets/components/helpers/shimmer_builder.dart';
import 'package:coffeecard/features/ticket/domain/entities/ticket.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/swipe_ticket_confirm.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

part 'tickets_card_placeholder.dart';

/// A card representing a group of tickets owned by the user.
///
/// See also [NoTicketsPlaceholder], which is used when the user has no tickets.
class TicketsCard extends StatelessWidget {
  /// Creates a [TicketsCard] with the given [ticket].
  const TicketsCard(this.ticket);

  /// A shimmering placeholder for a [TicketsCard].
  const TicketsCard.loadingPlaceholder() : ticket = const Ticket.empty();

  final Ticket ticket;

  bool get isLoadingPlaceholder => ticket == const Ticket.empty();

  @override
  Widget build(BuildContext context) {
    return ShimmerBuilder(
      showShimmer: isLoadingPlaceholder,
      builder: (context, colorIfShimmer) {
        return CardBase(
          color: isLoadingPlaceholder ? colorIfShimmer : AppColors.ticket,
          top: CardTitle(
            title: Text(ticket.product.name, style: AppTextStyle.ownedTicket),
          ),
          bottom: CardBottomRow(
            left: _TicketDots(amountOwned: ticket.amountLeft),
            right: _TicketAmountText(amountOwned: ticket.amountLeft),
          ),
          gap: 36,
          onTap: (context) {
            final _ = showSwipeTicketConfirm(context: context, ticket: ticket);
          },
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

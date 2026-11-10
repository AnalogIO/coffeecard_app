import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/helpers/shimmer_builder.dart';
import 'package:coffeecard/features/ticket/domain/entities/ticket.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/swipe_ticket_confirm.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

part 'tickets_card_placeholder.dart';

/// The two colourways of a clip card. Cards alternate between them so
/// different ticket types are easy to tell apart.
enum TicketTone {
  espresso(
    background: AppColors.espresso,
    foreground: AppColors.cream,
    muted: Color(0xb8F9F8F2),
    dot: Color(0xffE9DCC6),
    dotEmpty: Color(0x8CE9DCC6),
    pill: Color(0x24F9F8F2),
  ),
  caramel(
    background: AppColors.caramel,
    foreground: AppColors.roast,
    muted: AppColors.groundsDark,
    dot: AppColors.espresso,
    dotEmpty: Color(0x80362619),
    pill: Color(0x61FFFFFF),
  );

  const TicketTone({
    required this.background,
    required this.foreground,
    required this.muted,
    required this.dot,
    required this.dotEmpty,
    required this.pill,
  });

  final Color background;
  final Color foreground;
  final Color muted;
  final Color dot;
  final Color dotEmpty;
  final Color pill;

  static TicketTone forIndex(int index) => values[index % values.length];
}

/// A card representing a group of tickets owned by the user, drawn as a
/// clip card with punched notches.
///
/// See also [NoTicketsPlaceholder], which is used when the user has no tickets.
class TicketsCard extends StatelessWidget {
  /// Creates a [TicketsCard] with the given [ticket].
  const TicketsCard(this.ticket, {this.tone = TicketTone.espresso});

  /// A shimmering placeholder for a [TicketsCard].
  const TicketsCard.loadingPlaceholder()
      : ticket = const Ticket.empty(),
        tone = TicketTone.espresso;

  final Ticket ticket;
  final TicketTone tone;

  bool get isLoadingPlaceholder => ticket == const Ticket.empty();

  @override
  Widget build(BuildContext context) {
    return ShimmerBuilder(
      showShimmer: isLoadingPlaceholder,
      builder: (context, colorIfShimmer) {
        final mono = AppTextStyle.ticketFigure.copyWith(color: tone.foreground);
        final label = AppTextStyle.ticketLabel.copyWith(color: tone.muted);

        return Semantics(
          button: !isLoadingPlaceholder,
          label: '${ticket.product.name}, ${ticket.amountLeft} tickets left',
          excludeSemantics: true,
          child: ClipPath(
            clipper: const TicketNotchClipper(),
            child: Material(
              color: isLoadingPlaceholder ? colorIfShimmer : tone.background,
              child: InkWell(
                onTap: isLoadingPlaceholder
                    ? null
                    : () {
                        final _ = showSwipeTicketConfirm(
                          context: context,
                          ticket: ticket,
                        );
                      },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(Strings.ticketClipCard, style: label),
                                const SizedBox(height: 6),
                                Text(
                                  ticket.product.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.ownedTicket
                                      .copyWith(color: tone.foreground),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${ticket.amountLeft}', style: mono),
                              Text(Strings.ticketLeft, style: label),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                            child: _TicketDots(
                              amountOwned: ticket.amountLeft,
                              tone: tone,
                            ),
                          ),
                          const SizedBox(width: 12),
                          _UsePill(tone: tone),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Clips a rounded rectangle with a half-circle punched out of each side.
class TicketNotchClipper extends CustomClipper<Path> {
  const TicketNotchClipper({this.radius = 28, this.notchRadius = 12});

  final double radius;
  final double notchRadius;

  @override
  Path getClip(Size size) {
    final card = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );
    final notchY = size.height * .45;
    final notches = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(0, notchY), radius: notchRadius),
      )
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width, notchY),
          radius: notchRadius,
        ),
      );
    return Path.combine(PathOperation.difference, card, notches);
  }

  @override
  bool shouldReclip(TicketNotchClipper oldClipper) =>
      oldClipper.radius != radius || oldClipper.notchRadius != notchRadius;
}

class _TicketDots extends StatelessWidget {
  const _TicketDots({required this.amountOwned, required this.tone});

  final int amountOwned;
  final TicketTone tone;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: List.generate(10, (index) {
        final filled = amountOwned > index;
        return Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? tone.dot : Colors.transparent,
            border: filled ? null : Border.all(color: tone.dotEmpty),
          ),
        );
      }),
    );
  }
}

class _UsePill extends StatelessWidget {
  const _UsePill({required this.tone});
  final TicketTone tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: tone.pill,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Strings.ticketUse,
            style: AppTextStyle.buttonText.copyWith(color: tone.foreground),
          ),
          const SizedBox(width: 6),
          Icon(Icons.arrow_forward_rounded, size: 16, color: tone.foreground),
        ],
      ),
    );
  }
}

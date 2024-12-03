import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/dialog.dart';
import 'package:coffeecard/core/widgets/components/error_section.dart';
import 'package:coffeecard/core/widgets/components/loading_overlay.dart';
import 'package:coffeecard/core/widgets/components/section_title.dart';
import 'package:coffeecard/core/widgets/components/tickets_card.dart';
import 'package:coffeecard/features/environment/domain/entities/environment.dart';
import 'package:coffeecard/features/environment/presentation/cubit/environment_cubit.dart';
import 'package:coffeecard/features/opening_hours/presentation/widgets/opening_hours_indicator.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/receipt_overlay.dart';
import 'package:coffeecard/features/ticket/domain/entities/ticket.dart';
import 'package:coffeecard/features/ticket/presentation/cubit/tickets_cubit.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gap/gap.dart';

class TicketSection extends StatelessWidget {
  const TicketSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle.withSideWidget(
          Strings.ticketsMyTickets,
          sideWidget: OpeningHoursIndicator(),
        ),
        BlocConsumer<TicketsCubit, TicketsState>(
          listenWhen: (previous, current) => current is TicketsAction,
          listener: (context, state) {
            // Implicitly cast to TicketsLoaded
            // (the superclass of the Using, Used and UseError states)
            //
            // This is already checked in the listenWhen function, so this
            // is purely for type safety
            if (state is! TicketsAction) {
              throw StateError('This listener should not be called for $state');
            }

            switch (state) {
              case TicketUsing _:
                _whenTicketsUsing(context);
              case TicketUsed(:final receipt):
                _whenTicketUsed(context, receipt);
              case TicketsUseError(:final message):
                LoadingOverlay.hide(context);
                appDialog(
                  context: context,
                  title: Strings.error,
                  actions: [
                    TextButton(
                      child: const Text(Strings.buttonOK),
                      onPressed: () => closeAppDialog(context),
                    ),
                  ],
                  children: [Text(message, style: AppTextStyle.settingKey)],
                  dismissible: true,
                );
            }
          },
          buildWhen: (previous, current) => current is! TicketsAction,
          builder: (context, state) {
            return switch (state) {
              TicketsLoading _ => const TicketsCard.loadingPlaceholder(),
              TicketsLoaded(:final tickets) => LoadedTicketsSection(tickets),
              TicketsLoadError(:final message) => ErrorSection(
                  error: message,
                  retry: context.read<TicketsCubit>().getTickets,
                ),
            };
          },
        ),
        const Gap(4),
      ],
    );
  }

  void _whenTicketsUsing(BuildContext context) {
    // Remove the swipe overlay
    // (N/A when using a ticket as a part of the buy single drink flow)
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    LoadingOverlay.show(context);
  }

  void _whenTicketUsed(BuildContext context, Receipt receipt) {
    // Refresh or load user info (for updated rank stats)
    // (also refreshes leaderboard)
    context.read<UserCubit>().fetchUserDetails();

    final envState = context.read<EnvironmentCubit>().state;
    LoadingOverlay.hide(context);
    ReceiptOverlay.show(
      productName:
          receipt is SwipeReceipt ? receipt.menuItemName : receipt.productName,
      timeUsed: receipt.timeUsed,
      isTestEnvironment: envState is EnvironmentLoaded && envState.env.isTest,
      status: receipt is PurchaseReceipt
          ? receipt.paymentStatus.toString()
          : '${Strings.swiped} via ${receipt.productName} ticket',
      context: context,
    );
  }
}

/// The section that is shown when the tickets are loaded.
///
/// If the list of tickets is empty, a placeholder is shown.
class LoadedTicketsSection extends StatelessWidget {
  LoadedTicketsSection(List<Ticket> tickets)
      : maybeTickets = Option.fromPredicate(tickets, (ts) => ts.isNotEmpty);

  /// The list of tickets, or [None] if the list is empty.
  final Option<List<Ticket>> maybeTickets;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: maybeTickets.fold(
        () => [const NoTicketsPlaceholder()],
        (tickets) => tickets
            .map(
              (ticket) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Hero(
                  tag: 'ticket_${ticket.product.id}',
                  child: TicketsCard(ticket),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

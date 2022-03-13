import 'package:coffeecard/cubits/tickets/tickets_cubit.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/loading_overlay.dart';
import 'package:coffeecard/widgets/components/receipt/receipt_overlay.dart';
import 'package:coffeecard/widgets/components/tickets/coffee_card.dart';
import 'package:coffeecard/widgets/components/tickets/coffee_card_placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TicketSection extends StatelessWidget {
  const TicketSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl.get<TicketsCubit>(),
      child: Column(
        children: [
          BlocConsumer<TicketsCubit, TicketsState>(
            listener: (context, state) {
              if (state is TicketUsing) {
                Navigator.of(context, rootNavigator: true)
                    .pop(); //Removes the swipe overlay
                LoadingOverlay.of(context)
                    .show(); //TODO consider using a nicer loading indicator
              } else if (state is TicketUsed) {
                LoadingOverlay.of(context).hide(); //Removes the loading overlay
                ReceiptOverlay.of(context).show(state.receipt);
              }
            },
            builder: (context, state) {
              if (state is TicketsLoading) {
                final ticketsCubit = context.read<TicketsCubit>();
                ticketsCubit.getTickets();
                return const Text('loading');
              } else if (state is TicketsLoaded) {
                //States extending this are also caught on this
                if (state.tickets.isEmpty) {
                  return const CoffeeCardPlaceholder();
                }
                return Column(
                  children: state.tickets
                      .map(
                        (p) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: CoffeeCard(
                            title: p.productName,
                            amountOwned: p.count,
                            productId: p.productId,
                          ),
                        ),
                      )
                      .toList(),
                );
              } else if (state is TicketsError) {
                //FIXME: display error
                return const Text('error');
              }

              throw MatchCaseIncompleteException(this);
            },
          ),
        ],
      ),
    );
  }
}

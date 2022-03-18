import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/environment/environment_cubit.dart';
import 'package:coffeecard/cubits/tickets_page/tickets_cubit.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/coffee_card.dart';
import 'package:coffeecard/widgets/components/loading_overlay.dart';
import 'package:coffeecard/widgets/components/receipt/receipt_overlay.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TicketSection extends StatelessWidget {
  const TicketSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl.get<TicketsCubit>(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                Strings.ticketsMyTickets,
                style: AppTextStyle.sectionTitle,
              ),
            ),
            BlocConsumer<TicketsCubit, TicketsState>(
              listener: (context, state) {
                final environment = context.read<EnvironmentCubit>().state;
                if (state is TicketUsing) {
                  Navigator.pop(context); //Removes the swipe overlay
                  LoadingOverlay.of(context)
                      .show(); //TODO consider using a nicer loading indicator
                } else if (state is TicketUsed) {
                  Navigator.pop(context); //Removes the loading overlay
                  ReceiptOverlay.of(context).show(
                    receipt: state.receipt,
                    isTestEnvironment: environment is EnvironmentLoaded &&
                        environment.isTestEnvironment,
                  );
                }
              },
              builder: (context, state) {
                if (state is TicketsLoading) {
                  final ticketsCubit = context.read<TicketsCubit>();
                  ticketsCubit.getTickets();
                  return const Text('loading');
                } else if (state is TicketsLoaded) {
                  //States extending this are also caught on this
                  return Column(
                    children: state.tickets.isEmpty
                        ? [const EmptyCoffeeCard()]
                        : state.tickets
                            .map(
                              (p) => CoffeeCard(
                                title: p.productName,
                                amount: p.count,
                                productId: p.productId,
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
      ),
    );
  }
}

import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/tickets_page/tickets_cubit.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/coffee_card.dart';
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
              listener: (context, state) {},
              builder: (context, state) {
                if (state is TicketsLoading) {
                  final ticketsCubit = context.read<TicketsCubit>();
                  ticketsCubit.getTickets();
                  return const Text('loading');
                } else if (state is TicketsLoaded) {
                  return Column(
                    children: state.tickets.isEmpty
                        ? [const EmptyCoffeeCard()]
                        : state.tickets
                            .map(
                              (p) => CoffeeCard(
                                title: p.productName,
                                amount: p.count,
                              ),
                            )
                            .toList(),
                  );
                } else if (state is TicketsError) {
                  return const Text('error');
                }
                //FIXME: provide meaningfull error, maybe pass widget name?
                throw MatchCaseIncompleteException('match cases incomplete');
              },
            ),
          ],
        ),
      ),
    );
  }
}

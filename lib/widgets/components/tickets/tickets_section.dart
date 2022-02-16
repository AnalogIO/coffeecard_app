import 'package:coffeecard/cubits/tickets/tickets_cubit.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/widgets/components/tickets/coffee_card.dart';
import 'package:coffeecard/widgets/components/tickets/coffee_card_placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TicketSection extends StatelessWidget {
  const TicketSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketsCubit, TicketsState>(
      builder: (context, state) {
        if (state is TicketsLoading) return const Text('loading');
        if (state is TicketsLoaded) {
          if (state.tickets.isEmpty) {
            return const CoffeeCardPlaceholder();
          }
          return Column(
            children: state.tickets
                .map((t) => CoffeeCard(title: 'Espresso Based', amountOwned: 8))
                .toList(),
          );
        }
        if (state is TicketsError) return const Text('error');

        //FIXME: provide meaningfull error, maybe pass widget name?
        throw MatchCaseIncompleteException('match cases incomplete');
      },
    );
  }
}

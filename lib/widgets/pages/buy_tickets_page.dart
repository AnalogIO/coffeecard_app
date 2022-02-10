import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/buy_tickets_page/buy_tickets_cubit.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/widgets/components/ticket_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyTicketsPage extends StatefulWidget {
  const BuyTicketsPage({Key? key}) : super(key: key);

  @override
  _BuyTicketsPageState createState() => _BuyTicketsPageState();
}

class _BuyTicketsPageState extends State<BuyTicketsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BuyTicketsCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.buyTickets),
        ),
        body: BlocBuilder<BuyTicketsCubit, BuyTicketsState>(
          builder: (context, state) {
            if (state is BuyTicketsLoading) {
              final BuyTicketsCubit buyTicketsCubit =
                  context.read<BuyTicketsCubit>();
              buyTicketsCubit.getTickets();
              return const Text('loading');
            } else if (state is BuyTicketsLoaded) {
              return GridView.count(
                childAspectRatio: 2 / 3.1,
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: state.products
                    .map(
                      (e) => TicketCard(
                        id: e.id!,
                        title: e.name!,
                        text: e.description!,
                        amount: e.numberOfTickets!,
                        price: e.price!,
                      ),
                    )
                    .toList(),
              );
            } else if (state is BuyTicketsError) {
              return const Text('error');
            }
            //FIXME: provide meaningfull error, maybe pass widget name?
            throw MatchCaseIncompleteException('match cases incomplete');
          },
        ),
      ),
    );
  }
}

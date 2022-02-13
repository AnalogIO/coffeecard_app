import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/buy_tickets_page/buy_tickets_cubit.dart';
import 'package:coffeecard/data/repositories/v1/product_repository.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/helpers/grid.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/ticket_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyOneDrinkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BuyTicketsCubit(sl.get<ProductRepository>())..getTickets(),
      child: AppScaffold.withTitle(
        title: Strings.buyOneDrinkPageTitle,
        body: BlocBuilder<BuyTicketsCubit, BuyTicketsState>(
          builder: (context, state) {
            if (state is BuyTicketsFiltered) {
              return Grid(
                gap: GridGap.normal,
                gapSmall: GridGap.tight,
                singleColumnOnSmallDevice: true,
                children: state.filteredProducts
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
            } else if (state is BuyTicketsLoading) {
              return const Text('loading');
            } else if (state is BuyTicketsLoaded) {
              final BuyTicketsCubit buyTicketsCubit =
                  context.read<BuyTicketsCubit>();
              buyTicketsCubit.getFilteredProducts(FilterCategory.singleTickets);
              return const Text('Loading');
            } else if (state is BuyTicketsError) {
              //FIXME: display error properly
              return const Text('error');
            }

            throw MatchCaseIncompleteException(this);
          },
        ),
      ),
    );
  }
}

import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/buy_tickets_page/buy_tickets_cubit.dart';
import 'package:coffeecard/data/repositories/v1/product_repository.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/helpers/grid.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/tickets/buy_tickets_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyTicketsPage extends StatelessWidget {
  const BuyTicketsPage();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BuyTicketsCubit(sl.get<ProductRepository>())..getTickets(),
      child: AppScaffold.withTitle(
        title: Strings.buyTickets,
        body: BlocBuilder<BuyTicketsCubit, BuyTicketsState>(
          builder: (context, state) {
            if (state is BuyTicketsLoading) {
              return const Text('loading');
            } else if (state is BuyTicketsFiltered) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Grid(
                  gap: GridGap.normal,
                  gapSmall: GridGap.tight,
                  singleColumnOnSmallDevice: true,
                  children: state.filteredProducts
                      .map((product) => BuyTicketsCard(product: product))
                      .toList(),
                ),
              );
            } else if (state is BuyTicketsLoaded) {
              final BuyTicketsCubit buyTicketsCubit =
                  context.read<BuyTicketsCubit>();
              buyTicketsCubit.getFilteredProducts(FilterCategory.clipCards);
              return const Text('loading');
            } else if (state is BuyTicketsError) {
              return const Text('error');
            }

            throw MatchCaseIncompleteException(this);
          },
        ),
      ),
    );
  }
}

import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/products/products_cubit.dart';
import 'package:coffeecard/data/repositories/v1/product_repository.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/helpers/grid.dart';
import 'package:coffeecard/widgets/components/loading.dart';
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
          ProductsCubit(sl.get<ProductRepository>())..getTicketProducts(),
      child: AppScaffold.withTitle(
        title: Strings.buyTickets,
        body: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const Loading(loading: true);
            } else if (state is ProductsLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Grid(
                  gap: GridGap.normal,
                  gapSmall: GridGap.tight,
                  singleColumnOnSmallDevice: true,
                  children: state.products
                      .map((product) => BuyTicketsCard(product: product))
                      .toList(),
                ),
              );
            } else if (state is ProductsError) {
              // FIXME handle error
              return const Text('error');
            }

            throw MatchCaseIncompleteException(this);
          },
        ),
      ),
    );
  }
}

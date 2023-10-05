import 'package:coffeecard/core/firebase_analytics_event_logging.dart';
import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/error_section.dart';
import 'package:coffeecard/core/widgets/components/helpers/grid.dart';
import 'package:coffeecard/core/widgets/components/loading.dart';
import 'package:coffeecard/core/widgets/components/scaffold.dart';
import 'package:coffeecard/features/product/presentation/cubit/product_cubit.dart';
import 'package:coffeecard/features/product/presentation/widgets/buy_tickets_card.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuySingleDrinkPage extends StatelessWidget {
  const BuySingleDrinkPage();

  static const String fbAnalyticsListId = 'buy_one_drink';
  static const String fbAnalyticsListName = Strings.buyOneDrink;

  static Route get route =>
      MaterialPageRoute(builder: (_) => const BuySingleDrinkPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductCubit>()..getProducts(),
      child: AppScaffold.withTitle(
        title: Strings.buyOneDrink,
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const Loading(loading: true);
            } else if (state is ProductsLoaded) {
              sl<FirebaseAnalyticsEventLogging>().viewProductsListEvent(
                state.singleDrinks.toList(),
                fbAnalyticsListId,
                fbAnalyticsListName,
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Grid(
                  gap: GridGap.normal,
                  gapSmall: GridGap.tight,
                  singleColumnOnSmallDevice: true,
                  children: state.singleDrinks.map(BuyTicketsCard.new).toList(),
                ),
              );
            } else if (state is ProductsError) {
              return ErrorSection(
                error: state.error,
                retry: context.read<ProductCubit>().getProducts,
              );
            }

            throw ArgumentError(this);
          },
        ),
      ),
    );
  }
}

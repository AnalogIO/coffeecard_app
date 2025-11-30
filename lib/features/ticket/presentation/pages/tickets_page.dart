import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/barista_perks_section.dart';
import 'package:coffeecard/core/widgets/components/scaffold.dart';
import 'package:coffeecard/features/product/presentation/cubit/product_cubit.dart';
import 'package:coffeecard/features/ticket/presentation/cubit/tickets_cubit.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/shop_section.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/tickets_section.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upgrader/upgrader.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({required this.scrollController});

  final ScrollController scrollController;

  static Route routeWith({required ScrollController scrollController}) {
    return MaterialPageRoute(
      builder: (_) => TicketsPage(scrollController: scrollController),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productState = context.read<ProductCubit>().state;
    if (productState is! ProductsLoaded) {
      // Failsafe, in case we somehow made it to the tickets page without loading the products
      // Can seemingly happen with some deep links
      context.read<ProductCubit>().getProducts();
    }
    final perksAvailable = productState is ProductsLoaded &&
        productState.products.perks.isNotEmpty;

    return UpgradeAlert(
      child: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
        return AppScaffold.withTitle(
          title: Strings.ticketsPageTitle,
          body: RefreshIndicator(
            onRefresh: context.read<TicketsCubit>().getTickets,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      const TicketSection(),
                      if (state is UserLoaded && perksAvailable)
                        BaristaPerksSection(userRole: state.user.role),
                      const ShopSection(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

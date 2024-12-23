import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/barista_perks_section.dart';
import 'package:coffeecard/core/widgets/components/scaffold.dart';
import 'package:coffeecard/features/product/purchasable_products.dart';
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
    final user = (context.read<UserCubit>().state as UserLoaded).user;
    final perksAvailable = context.read<PurchasableProducts>().perks.isNotEmpty;

    return UpgradeAlert(
      child: AppScaffold.withTitle(
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
                    if (perksAvailable)
                      BaristaPerksSection(userRole: user.role),
                    const ShopSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:coffeecard/core/extensions/string_extensions.dart';
import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/barista_perks_section.dart';
import 'package:coffeecard/core/widgets/components/scaffold.dart';
import 'package:coffeecard/core/widgets/upgrade_alert.dart';
import 'package:coffeecard/features/product/product_model.dart';
import 'package:coffeecard/features/product/purchasable_products.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/shop_section.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/tickets_section.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return UpgradeAlert(
      child: BlocBuilder<UserCubit, UserState>(
        buildWhen: (_, current) => current is UserWithData,
        builder: (context, state) {
          if (state is! UserWithData) {
            return const Center(child: CircularProgressIndicator());
          }
          return _TicketsContent(
            scrollController: scrollController,
            userRole: state.user.role.name.capitalize(),
            perks: context.watch<PurchasableProducts>().perks,
          );
        },
      ),
    );
  }
}

/// The content of the tickets page, shown when user info is loaded.
class _TicketsContent extends StatelessWidget {
  const _TicketsContent({
    required this.scrollController,
    required this.userRole,
    required this.perks,
  });

  final ScrollController scrollController;
  final String userRole;
  final Iterable<Product> perks;

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.ticketsPageTitle,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              controller: scrollController,
              shrinkWrap: true,
              padding: const EdgeInsets.all(16.0),
              children: [
                const TicketSection(),
                if (perks.isNotEmpty) BaristaPerksSection(userRole, perks),
                const ShopSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

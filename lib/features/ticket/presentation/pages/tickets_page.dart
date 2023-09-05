import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/core/widgets/upgrade_alert.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/shop_section.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/tickets_section.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

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
      child: AppScaffold.withTitle(
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionTitle(Strings.ticketsMyTickets),
                    ],
                  ),
                  const TicketSection(),
                  const Gap(24),
                  if ((context.read<UserCubit>().state as UserLoaded)
                      .user
                      .hasBaristaPerks)
                    const SectionTitle(Strings.baristaPerks),
                  const SectionTitle(Strings.shopText),
                  const ShopSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

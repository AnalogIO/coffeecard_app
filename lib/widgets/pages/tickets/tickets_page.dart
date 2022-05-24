import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/section_title.dart';
import 'package:coffeecard/widgets/components/tickets/opening_hours_indicator.dart';
import 'package:coffeecard/widgets/components/tickets/shop_section.dart';
import 'package:coffeecard/widgets/components/tickets/tickets_section.dart';
import 'package:flutter/material.dart';
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SectionTitle(Strings.ticketsMyTickets),
                    OpeningHoursIndicator(),
                  ],
                ),
                const TicketSection(),
                const Gap(24),
                const SectionTitle(Strings.shopText),
                const ShopSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

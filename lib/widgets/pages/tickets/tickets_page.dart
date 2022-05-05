import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/section_title.dart';
import 'package:coffeecard/widgets/components/tickets/shop_section.dart';
import 'package:coffeecard/widgets/components/tickets/tickets_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({required this.scrollController});

  final ScrollController scrollController;

  static Route routeWith({required ScrollController scrollController}) =>
      MaterialPageRoute(
        builder: (_) => TicketsPage(scrollController: scrollController),
      );

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
              children: const [
                SectionTitle(Strings.ticketsMyTickets),
                TicketSection(),
                Gap(24),
                SectionTitle(Strings.shopText),
                ShopSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

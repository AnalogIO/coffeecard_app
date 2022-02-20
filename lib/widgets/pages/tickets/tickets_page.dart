import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/section_title.dart';
import 'package:coffeecard/widgets/components/tickets/analog_closed_popup.dart';
import 'package:coffeecard/widgets/components/tickets/shop_section.dart';
import 'package:coffeecard/widgets/components/tickets/tickets_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({Key? key}) : super(key: key);

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.ticketsPageTitle,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AnalogClosedPopup(),
          Expanded(
            child: ListView(
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

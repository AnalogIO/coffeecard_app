import 'package:coffeecard/widgets/components/analog_closed_popup.dart';
import 'package:coffeecard/widgets/components/shop_section.dart';
import 'package:coffeecard/widgets/components/tickets_section.dart';
import 'package:flutter/material.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({Key? key}) : super(key: key);

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        AnalogClosedPopup(),
        TicketSection(),
        ShopSection(),
      ],
    );
  }
}

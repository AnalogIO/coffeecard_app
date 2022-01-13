import 'package:coffeecard/widgets/components/ticket_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BuyTicketsPage extends StatelessWidget {
  const BuyTicketsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy tickets'),
      ),
      body: GridView.count(
        childAspectRatio: 0.8,
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          TicketCard(
            title: 'Filter coffee',
            text: 'Used for filter coffee brewed with fresh ground coffee',
            amount: 10,
            price: 80,
            onTap: () {},
          ),
          TicketCard(
            title: 'Espresso Based',
            text: 'Used for all espresso based drinks, hot or cold',
            amount: 10,
            price: 150,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

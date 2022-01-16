import 'dart:convert';

import 'package:coffeecard/api_service.dart';
import 'package:coffeecard/widgets/components/ticket_card.dart';
import 'package:flutter/material.dart';

class Ticket {
  final int id;
  final int price;
  final int numberOfTickets;
  final String name;
  final String description;

  Ticket({
    required this.id,
    required this.price,
    required this.numberOfTickets,
    required this.name,
    required this.description,
  });

  Ticket.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        price = json['price'] as int,
        numberOfTickets = json['numberOfTickets'] as int,
        name = json['name'] as String,
        description = json['description'] as String;

  @override
  String toString() {
    return '($id, $price, $numberOfTickets, $name, $description';
  }
}

Future<List<Ticket>> getAvailableTickets() async {
  final response = await APIService.getJSON('Products');

  if (response.statusCode == 200) {
    final List<dynamic> ticketsList =
        json.decode(response.body) as List<dynamic>;

    final List<Ticket> tickets = [];
    for (final ticket in ticketsList) {
      final Ticket r = Ticket.fromJson(ticket as Map<String, dynamic>);
      tickets.add(r);
    }
    return tickets;
  }
  return [];
}

class BuyTicketsPage extends StatefulWidget {
  const BuyTicketsPage({Key? key}) : super(key: key);

  @override
  _BuyTicketsPageState createState() => _BuyTicketsPageState();
}

class _BuyTicketsPageState extends State<BuyTicketsPage> {
  List<Ticket> availableTickets = [];
  bool isLoading = false;

  Future<void> fetch() async {
    setState(() {
      isLoading = true;
    });

    availableTickets = await getAvailableTickets();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    //FIXME handle loading
    if (isLoading) return const Scaffold();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy tickets'),
      ),
      body: GridView.count(
        childAspectRatio: 2 / 3,
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: availableTickets
            .map(
              (e) => TicketCard(
                id: e.id,
                title: e.name,
                text: e.description,
                amount: e.numberOfTickets,
                price: e.price,
              ),
            )
            .toList(),
      ),
    );
  }
}

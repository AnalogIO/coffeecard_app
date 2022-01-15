import 'package:coffeecard/widgets/components/drink_card.dart';
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

class BuyOneDrinkPage extends StatefulWidget {
  const BuyOneDrinkPage({Key? key}) : super(key: key);

  @override
  _BuyOneDrinkPageState createState() => _BuyOneDrinkPageState();
}

class _BuyOneDrinkPageState extends State<BuyOneDrinkPage> {
  List<Ticket> availableTickets = [];
  bool isLoading = false;

  Future<void> fetch() async {
    setState(() {
      isLoading = true;
    });

    availableTickets = [];

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
    return Scaffold(
      appBar: AppBar(title: const Text('Buy one drink')),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          DrinkCard(
            title: 'Filter coffee',
            options: const {'Per cup': 10},
            price: 80,
            onTap: () {},
          ),
          DrinkCard(
            title: 'Caffe latte',
            options: const {'Single': 17, 'Double': 20},
            price: 80,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

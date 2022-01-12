import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CoffeeCard extends StatelessWidget {
  final String title;
  final int amount;

  const CoffeeCard({Key? key, required this.title, required this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Row(children: [
            Container(), //Clips?
            Text('Tickets left $amount')
          ],)
        ],
      ),
    );
  }
}

import 'package:coffeecard/widgets/components/drink_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BuyOneDrinkPage extends StatelessWidget {
  const BuyOneDrinkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
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
    );
  }
}

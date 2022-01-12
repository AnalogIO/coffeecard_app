import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ShopCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onPressed;

  const ShopCard(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(title),
          IconButton(
            icon: Icon(icon),
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}

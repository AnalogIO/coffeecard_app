import 'package:coffeecard/base/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TicketDisplay extends StatelessWidget {
  final int amount;

  const TicketDisplay({required this.amount, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: makeRow(amount),
    );
  }
}

List<Row> makeRow(int amount) {
  int amnt = amount;
  final List<Circle> firstRow = [];
  final List<Circle> secondRow = [];

  for (int i = 0; i < 5; i++) {
    firstRow.add(Circle(used: amnt <= 0));
    amnt--;
  }

  for (int i = 0; i < 5; i++) {
    secondRow.add(Circle(used: amnt <= 0));
    amnt--;
  }

  final List<Row> rows = [];
  rows.add(
    Row(
      children: firstRow,
    ),
  );

  rows.add(
    Row(
      children: secondRow,
    ),
  );

  return rows;
}

class Circle extends StatelessWidget {
  final bool used;

  const Circle({required this.used, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: 15,
        height: 15,
        decoration: BoxDecoration(
          color: used ? AppColor.ticket : AppColor.secondary,
          shape: BoxShape.circle,
          border: Border.all(width: 1.5),
        ),
      ),
    );
  }
}

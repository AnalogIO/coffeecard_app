import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:coffeecard/widgets/components/slide_button.dart';
import 'package:flutter/material.dart';

class CoffeeCard extends StatelessWidget {
  final String title;
  final int amount;

  const CoffeeCard({Key? key, required this.title, required this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tappable(
      child: SizedBox(
        height: 150,
        child: Card(
          color: AppColor.ticket,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: AppTextStyle.ownedTicket,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TicketDisplay(
                        amount: amount,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: [
                          Text(
                            'Tickets left:',
                            style: AppTextStyle.textField,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              '$amount',
                              style: AppTextStyle.ticketsCount,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () => {
        showModalBottomSheet(
          context: context,
          builder: (builder) {
            return UseCoffeeCardWidget(
              title: title,
            );
          },
        )
      },
    );
  }
}

class UseCoffeeCardWidget extends StatefulWidget {
  final String title;

  const UseCoffeeCardWidget({Key? key, required this.title}) : super(key: key);

  @override
  _UseCoffeeCardWidgetState createState() => _UseCoffeeCardWidgetState();
}

class _UseCoffeeCardWidgetState extends State<UseCoffeeCardWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title),
            SlideButton(
              onSwipeComplete: () {
                // ignore: avoid_print
                print('swipe complete');
              },
            )
          ],
        ),
      ),
    );
  }
}

class EmptyCoffeeCard extends StatelessWidget {
  const EmptyCoffeeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Card(
        color: AppColor.background,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColor.secondary, width: 2),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Strings.emptyCoffeeCardTextTop,
                  style: AppTextStyle.textField,
                ),
                Text(
                  Strings.emptyCoffeeCardTextBottom,
                  style: AppTextStyle.textField,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

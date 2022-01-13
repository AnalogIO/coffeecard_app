import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/ticket_display.dart';
import 'package:flutter/material.dart';

class CoffeeCard extends StatelessWidget {
  final String title;
  final int amount;

  const CoffeeCard({Key? key, required this.title, required this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                  'Tickets that you buy will show up here',
                  style: AppTextStyle.textField,
                ),
                Text(
                  'Use the section below to shop tickets.',
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

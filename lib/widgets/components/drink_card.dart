import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:flutter/material.dart';

class DrinkCard extends StatelessWidget {
  final String title;
  final Map<String, int> options; //{"single": 17, "double": 20}
  final int price;
  final Function() onTap;

  const DrinkCard({
    Key? key,
    required this.title,
    required this.options,
    required this.price,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: onTap,
      child: Card(
        color: AppColor.white,
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
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    title,
                    style: AppTextStyle.ownedTicket,
                  ),
                ),
              ),
              Row(
                children: options.entries
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.key,
                              style: AppTextStyle.textField,
                            ),
                            Text(
                              '${e.value},-',
                              style: AppTextStyle.ticketsCount,
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
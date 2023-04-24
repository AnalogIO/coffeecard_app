import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:flutter/material.dart';

class SingleCoffeeCard extends StatelessWidget {
  final String title;

  /// prices in the format {"single": 17, "double": 20}.
  final Map<String, int> options;

  final int price;
  final Function() onTap;

  const SingleCoffeeCard({
    required this.title,
    required this.options,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: onTap,
      child: Card(
        color: AppColor.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25)),
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
                              Strings.price(e.value),
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

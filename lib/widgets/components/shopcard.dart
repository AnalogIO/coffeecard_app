import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ShopCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onPressed;

  const ShopCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 180,
      child: Card(
        color: AppColor.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Tappable(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColor.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    icon,
                    color: AppColor.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

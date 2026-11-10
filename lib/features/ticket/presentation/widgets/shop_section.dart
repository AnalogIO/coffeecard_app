import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/helpers/grid.dart';
import 'package:coffeecard/core/widgets/components/section_title.dart';
import 'package:coffeecard/features/product/presentation/pages/buy_single_drink_page.dart';
import 'package:coffeecard/features/product/presentation/pages/buy_tickets_page.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/shop_card.dart';
import 'package:flutter/material.dart';

class ShopSection extends StatelessWidget {
  const ShopSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        const SectionTitle(Strings.shopText),
        Grid(
          singleColumnOnSmallDevice: false,
          gap: GridGap.tightVertical,
          gapSmall: GridGap.tight,
          children: [
            ShopCard(
              title: Strings.buyTickets,
              optionalText: Strings.buyTicketsSubtitle,
              icon: Icons.confirmation_num_outlined,
              onTapped: (_) => Navigator.push(context, BuyTicketsPage.route),
            ),
            ShopCard(
              title: Strings.buyOneDrink,
              optionalText: Strings.buyOneDrinkSubtitle,
              icon: Icons.sell_outlined,
              onTapped: (_) =>
                  Navigator.push(context, BuySingleDrinkPage.route),
            ),
          ],
        ),
      ],
    );
  }
}

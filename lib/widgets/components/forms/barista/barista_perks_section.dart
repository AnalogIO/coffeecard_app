import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/features/product/presentation/pages/buy_single_drink_page.dart';
import 'package:coffeecard/features/product/presentation/pages/buy_tickets_page.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/shop_card.dart';
import 'package:coffeecard/widgets/components/forms/barista/barista_indicator.dart';
import 'package:coffeecard/widgets/components/helpers/grid.dart';
import 'package:coffeecard/widgets/components/section_title.dart';
import 'package:flutter/material.dart';

class BaristaPerksSection extends StatelessWidget {
  const BaristaPerksSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SectionTitle(Strings.baristaPerks),
            BaristaIndicator(),
          ],
        ),
        Grid(
          singleColumnOnSmallDevice: false,
          gap: GridGap.tightVertical,
          gapSmall: GridGap.tight,
          children: [
            ShopCard(
              title: Strings.baristaClaimOnShiftDrink,
              icon: Icons.coffee,
              onTapped: (_) => Navigator.push(context, BuyTicketsPage.route),
            ),
            ShopCard(
              title: Strings.baristaClaimFreeFilter,
              icon: Icons.coffee_maker,
              onTapped: (_) =>
                  Navigator.push(context, BuySingleDrinkPage.route),
            ),
            ShopCard(
              title: Strings.buyOneDrink,
              icon: Icons.coffee,
              onTapped: (context) => buyTicketsModal,
              optionalText: '6,-',
            ),
          ],
        ),
      ],
    );
  }
}
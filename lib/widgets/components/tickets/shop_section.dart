import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/helpers/grid.dart';
import 'package:coffeecard/widgets/components/tickets/shop_card.dart';
import 'package:coffeecard/widgets/routers/tickets_flow.dart';
import 'package:flutter/material.dart';

class ShopSection extends StatelessWidget {
  const ShopSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Grid(
          singleColumnOnSmallDevice: false,
          gap: GridGap.tightVertical,
          gapSmall: GridGap.tight,
          children: [
            ShopCard(
              title: Strings.buyTickets,
              icon: Icons.style,
              type: ShopCardType.newFeature,
              onTapped: (_) => TicketsFlow.push(TicketsFlow.buyTicketsRoute),
            ),
            ShopCard(
              title: Strings.buyOneDrink,
              icon: Icons.coffee,
              type: ShopCardType.comingSoon,
            ),
            ShopCard(
              title: Strings.buyOther,
              icon: Icons.coffee_maker,
              type: ShopCardType.comingSoon,
            ),
            ShopCard(
              title: Strings.redeemVoucher,
              icon: Icons.wallet_giftcard,
              onTapped: (_) => TicketsFlow.push(TicketsFlow.redeemVoucherRoute),
            ),
          ],
        ),
      ],
    );
  }
}

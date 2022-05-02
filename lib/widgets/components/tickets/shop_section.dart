import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/helpers/grid.dart';
import 'package:coffeecard/widgets/components/tickets/shop_card.dart';
import 'package:coffeecard/widgets/pages/tickets/buy_tickets_page.dart';
import 'package:coffeecard/widgets/pages/tickets/redeem_voucher_page.dart';
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
              icon: Icons.confirmation_num,
              onTapped: (_) => Navigator.push(context, BuyTicketsPage.route),
            ),
            const ShopCard(
              title: Strings.buyOneDrink,
              icon: Icons.coffee,
              type: ShopCardType.comingSoon,
            ),
            const ShopCard(
              title: Strings.buyOther,
              icon: Icons.coffee_maker,
              type: ShopCardType.comingSoon,
            ),
            ShopCard(
              title: Strings.redeemVoucher,
              icon: Icons.wallet_giftcard,
              onTapped: (_) => Navigator.push(context, RedeemVoucherPage.route),
            ),
          ],
        ),
      ],
    );
  }
}

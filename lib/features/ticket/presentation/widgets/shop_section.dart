import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/features/product/presentation/pages/buy_single_drink_page.dart';
import 'package:coffeecard/features/product/presentation/pages/buy_tickets_page.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/shop_card.dart';
import 'package:coffeecard/features/voucher/presentation/pages/redeem_voucher_page.dart';
import 'package:coffeecard/widgets/components/helpers/grid.dart';
import 'package:flutter/material.dart';

class ShopSection extends StatelessWidget {
  const ShopSection();

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
            ShopCard(
              title: Strings.buyOneDrink,
              icon: Icons.coffee,
              onTapped: (_) =>
                  Navigator.push(context, BuySingleDrinkPage.route),
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

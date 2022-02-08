import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/cards/shop_card.dart';
import 'package:coffeecard/widgets/components/grid.dart';
import 'package:coffeecard/widgets/pages/buy_one_drink_page.dart';
import 'package:coffeecard/widgets/pages/buy_other_page.dart';
import 'package:coffeecard/widgets/pages/buy_tickets_page.dart';
import 'package:coffeecard/widgets/pages/redeem_voucher_page.dart';
import 'package:flutter/material.dart';

class ShopSection extends StatelessWidget {
  const ShopSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(Strings.shopText, style: AppTextStyle.sectionTitle),
          ),
          //FIXME: adjust card size, this wil hopefully get fixed when ShopCard extends CardBase
          FourGrid(
            tl: ShopCard(
              title: Strings.buyTickets,
              icon: Icons.style,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BuyTicketsPage(),
                  ),
                );
              },
            ),
            tr: ShopCard(
              title: Strings.buyOneDrink,
              icon: Icons.coffee,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BuyOneDrinkPage(),
                  ),
                );
              },
            ),
            bl: ShopCard(
              title: Strings.buyOther,
              icon: Icons.coffee,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BuyOtherPage(),
                  ),
                );
              },
            ),
            br: ShopCard(
              title: Strings.redeemVoucher,
              icon: Icons.wallet_giftcard,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RedeemVoucherPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

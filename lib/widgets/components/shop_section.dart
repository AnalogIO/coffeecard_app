import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/shop_card.dart';
import 'package:coffeecard/widgets/components/shop_card_disabled.dart';
//import 'package:coffeecard/widgets/pages/buy_one_drink_page.dart';
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
          GridView.count(
            childAspectRatio: 3 / 2,
            primary: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            crossAxisCount: 2,
            children: [
              ShopCard(
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
              const ShopCardDisabled(
                // in future change this class back to ShopCard when feature is ready
                title: Strings.buyOneDrink,
                icon: Icons.coffee,
                // onPressed: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const BuyOneDrinkPage(),
                //     ),
                //   );
                // },
              ),
              ShopCard(
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
              ShopCard(
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
            ],
          )
        ],
      ),
    );
  }
}

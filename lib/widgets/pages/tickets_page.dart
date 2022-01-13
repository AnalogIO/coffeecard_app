import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/coffee_card.dart';
import 'package:coffeecard/widgets/components/shop_card.dart';
import 'package:coffeecard/widgets/pages/buy_one_drink_page.dart';
import 'package:coffeecard/widgets/pages/buy_other_page.dart';
import 'package:coffeecard/widgets/pages/buy_tickets_page.dart';
import 'package:coffeecard/widgets/pages/redeem_voucher_page.dart';
import 'package:flutter/material.dart';

//static const platform = MethodChannel('samples.flutter.dev');
//await platform.invokeMethod('foo');

class TicketsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('My tickets', style: AppTextStyle.sectionTitle),
          ),
          Column(
            children: const [
              CoffeeCard(title: 'Espresso Based', amount: 8),
              EmptyCoffeeCard()
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
            child: Text('Shop', style: AppTextStyle.sectionTitle),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ShopCard(
                title: 'Buy tickets',
                icon: Icons.style,
                onPressed: () {
                  //TODO: proper navigation!
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BuyTicketsPage(),
                    ),
                  );
                },
              ),
              ShopCard(
                title: 'Buy one drink',
                icon: Icons.coffee,
                onPressed: () {
                  //TODO: proper navigation!
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BuyOneDrinkPage(),
                    ),
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ShopCard(
                title: 'Buy syrup, jugs etc.',
                icon: Icons.coffee,
                onPressed: () {
                  //TODO: proper navigation!
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BuyOtherPage(),
                    ),
                  );
                },
              ),
              ShopCard(
                title: 'Redeem voucher',
                icon: Icons.wallet_giftcard,
                onPressed: () {
                  //TODO: proper navigation!
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RedeemVoucherPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

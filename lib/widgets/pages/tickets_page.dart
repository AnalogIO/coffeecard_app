import 'package:coffeecard/base/style/colors.dart';
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
    return ListView(
      children: const [
        AnalogClosed(isClosed: true),
        TicketSection(),
        ShopSection(),
      ],
    );
  }
}

class AnalogClosed extends StatelessWidget {
  final bool isClosed;

  const AnalogClosed({Key? key, required this.isClosed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isClosed) {
      return Container(
        color: AppColor.secondary,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Cafe Analog is closed',
                style: AppTextStyle.buttonText,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'Oh no!',
                style: AppTextStyle.buttonText,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    'Got it',
                    style: AppTextStyle.buttonText,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    return Container();
  }
}

class TicketSection extends StatelessWidget {
  const TicketSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text('My tickets', style: AppTextStyle.sectionTitle),
          ),
          Column(
            children: const [
              CoffeeCard(title: 'Espresso Based', amount: 8),
              EmptyCoffeeCard()
            ],
          ),
        ],
      ),
    );
  }
}

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
            child: Text('Shop', style: AppTextStyle.sectionTitle),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ShopCard(
                title: 'Buy tickets',
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
              ShopCard(
                title: 'Buy one drink',
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
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ShopCard(
                title: 'Buy syrup, jugs etc.',
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
                title: 'Redeem voucher',
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
          ),
        ],
      ),
    );
  }
}

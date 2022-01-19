import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/coffee_card.dart';
import 'package:coffeecard/widgets/components/rounded_button.dart';
import 'package:coffeecard/widgets/components/shop_card.dart';
import 'package:coffeecard/widgets/pages/buy_one_drink_page.dart';
import 'package:coffeecard/widgets/pages/buy_other_page.dart';
import 'package:coffeecard/widgets/pages/buy_tickets_page.dart';
import 'package:coffeecard/widgets/pages/redeem_voucher_page.dart';
import 'package:flutter/material.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({Key? key}) : super(key: key);

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  bool hasClosedAnalogClosedPopup = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AnalogClosed(
          isClosed: true,
          hasClosedPopup: hasClosedAnalogClosedPopup,
          onClosePopup: () => {
            setState(() { hasClosedAnalogClosedPopup = true; })
          },
        ),
        const TicketSection(),
        const ShopSection(),
      ],
    );
  }
}

class AnalogClosed extends StatelessWidget {
  final bool isClosed;
  final bool hasClosedPopup;
  final Function() onClosePopup;

  const AnalogClosed(
      {Key? key, required this.isClosed, required this.hasClosedPopup, required this.onClosePopup,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!hasClosedPopup && isClosed) {
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
            RoundedButton(
              text: 'Got it',
              onPressed: onClosePopup,
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
          )
        ],
      ),
    );
  }
}

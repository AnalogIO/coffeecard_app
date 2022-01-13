import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/payment/payment_service.dart';
import 'package:coffeecard/widgets/components/coffeecard.dart';
import 'package:coffeecard/widgets/components/shopcard.dart';
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
                  final service = PaymentService();

                  final payment = service.initPurchase('');

                  service.invokeMobilePay(payment);

                  //TODO
                  service.verifyPurchaseOrRetry(payment.paymentId);

                  //Refresh
                },
              ),
              ShopCard(
                title: 'Buy one drink',
                icon: Icons.coffee,
                onPressed: () {},
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ShopCard(
                title: 'Buy syrup, jugs etc.',
                icon: Icons.coffee,
                onPressed: () {},
              ),
              ShopCard(
                title: 'Redeem voucher',
                icon: Icons.wallet_giftcard,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
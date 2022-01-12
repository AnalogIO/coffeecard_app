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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My tickets', style: AppTextStyle.sectionTitle),
          Column(
            children: const [CoffeeCard(title: 'Espresso Based', amount: 2)],
          ),
          Text('Shop', style: AppTextStyle.sectionTitle),
          Row(
            children: [
              ShopCard(
                title: 'Buy tickets',
                icon: Icons.wallet_giftcard,
                onPressed: () {
                  final service = PaymentService();

                  final payment = service.initPurchase('');

                  service.invokeMobilePay(payment);

                  var status = service.verifyPurchaseOrRetry(payment.paymentId);

                  //Refresh
                },
              ),
              ShopCard(
                title: 'Buy one drink',
                icon: Icons.edit,
                onPressed: () {},
              ),
            ],
          ),
          Row(
            children: [
              ShopCard(
                title: 'Buy syrup, jugs etc.',
                icon: Icons.edit,
                onPressed: () {},
              ),
              ShopCard(
                title: 'Redeem voucher',
                icon: Icons.edit,
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

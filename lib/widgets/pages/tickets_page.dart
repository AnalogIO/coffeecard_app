import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/payment/payment_service.dart';
import 'package:flutter/material.dart';

//static const platform = MethodChannel('samples.flutter.dev');
//await platform.invokeMethod('foo');

class TicketsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
                  
        Text('My tickets', style: AppTextStyle.sectionTitle),
        Container(), //TODO: display tickets
        Text('Shop', style: AppTextStyle.sectionTitle),
        Row(
          children: [
            IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  final service = PaymentService();

                  final payment = service.initPurchase('');

                  service.invokeMobilePay(payment);

                  var status = service.verifyPurchaseOrRetry(payment.paymentId);

                  //Refresh
                })
          ],
        ), //TODO: should contain correct widgets, placeholder for now
        Row(),
      ],
    );
  }
}

import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/utils/time_since.dart';
import 'package:coffeecard/widgets/analog_logo.dart';
import 'package:coffeecard/widgets/components/generic_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateFormat get _formatter => DateFormat('EEEE d/M HH:mm');

class ReceiptCard extends StatelessWidget {
  final String productName;
  final DateTime time;
  final bool isPurchase;
  final bool isInOverlay;

  const ReceiptCard({
    required this.productName,
    required this.time,
    required this.isPurchase,
    required this.isInOverlay,
  });

  @override
  Widget build(BuildContext context) {
    return CardGeneric(
      //TODO have someone look over the numbers and the text styles used
      width: 200,
      height: 200,
      borderRadius: 24,
      padding: 32,
      children: [
        Text(
          isPurchase ? 'Purchased' : 'Used ticket',
          style: AppTextStyle.textField,
        ),
        Text(
          productName,
          style: AppTextStyle.sectionTitle,
        ),
        Text(
          timeSince(time),
          style: AppTextStyle.textFieldBold,
        ),
        Text(
          _formatter.format(time),
          style: AppTextStyle.textField,
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              //Flexible to ensure the text will wrap if given a long string
              child: Text(
                isInOverlay ? 'This can be found again under Reciepts.' : '',
                style: AppTextStyle.explainer,
              ),
            ),
            AnalogRecieptLogo()
          ],
        )
      ],
    );
  }
}

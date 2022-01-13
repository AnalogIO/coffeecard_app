import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/widgets/analog_logo.dart';
import 'package:coffeecard/widgets/components/generic_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReceiptCard extends StatelessWidget {
  final Receipt receipt;
  final Function() onTap;
  final String? optionalText;

  const ReceiptCard({
    required this.receipt,
    required this.onTap,
    this.optionalText,
  });

  DateFormat get formatter => DateFormat('EEEE dd/MM HH:mm');

  String timeSincePurchase(Receipt receipt) {
    final currentTime = DateTime.now();
    final difference = currentTime.difference(receipt.timeUsed);
    if (difference.inMinutes < 2) {
      //If the ticket was used within the last two minutes,
      // it is showed as having just been used
      return 'Used just now';
    }
    return 'Used ${difference.inDays} days ago';
  }

  @override
  Widget build(BuildContext context) {
    return CardGeneric(
      //TODO have someone look over the numbers and the text styles used
      width: 200,
      height: 200,
      borderRadius: 24,
      padding: 32,
      onTap: onTap,
      children: [
        Text(
          receipt.transactionType == TransactionType.purchase
              ? 'Bought ${receipt.amountPurchased} Tickets'
              : 'Used ${receipt.amountPurchased} Ticket',
          style: AppTextStyle.textField,
        ),
        Text(
          receipt.productName,
          style: AppTextStyle.sectionTitle,
        ),
        Text(
          timeSincePurchase(receipt),
          style: AppTextStyle.textFieldBold,
        ),
        Text(
          formatter.format(receipt.timeUsed),
          style: AppTextStyle.textField,
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              //Flexible to ensure the text will wrap if given a long string
              child: Text(
                optionalText ?? '',
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

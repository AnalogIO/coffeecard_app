import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:coffeecard/widgets/components/purchase/purchase_overlay.dart';
import 'package:coffeecard/widgets/components/rounded_button.dart';
import 'package:flutter/material.dart';

class TicketCard extends StatelessWidget {
  final String title;
  final String text;
  final int amount;
  final int price;
  final int id;

  const TicketCard({
    Key? key,
    required this.id,
    required this.title,
    required this.text,
    required this.amount,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tappable(
      child: Card(
        color: AppColor.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        title,
                        style: AppTextStyle.ownedTicket,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      text,
                      style: AppTextStyle.label,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      Strings.amountTickets(amount),
                      style: AppTextStyle.textField,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      Strings.price(price),
                      style: AppTextStyle.ticketsCount,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (builder) {
            return SizedBox(
              height: 120,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child:
                            Text(Strings.paymentConfirmationTop(amount, title)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(Strings.paymentConfirmationBottom(price)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RoundedButton(
                          disabled: true,
                          text: Strings.paymentOptionApplePay,
                          onPressed: () async {
                            //TODO add function call;
                          },
                        ),
                        RoundedButton(
                          text: Strings.paymentOptionMobilePay,
                          onPressed: () async {
                            PurchaseOverlay.of(context)
                                .show(InternalPaymentType.mobilePay, id);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

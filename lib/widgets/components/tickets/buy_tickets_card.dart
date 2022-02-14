import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:coffeecard/widgets/components/card.dart';
import 'package:coffeecard/widgets/components/purchase/purchase_overlay.dart';
import 'package:coffeecard/widgets/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BuyTicketsCard extends CardBase {
  final String title;
  final String description;
  final int amount;
  final int price;
  final int productId;

  BuyTicketsCard({
    Key? key,
    required this.productId,
    required this.title,
    required this.description,
    required this.amount,
    required this.price,
  }) : super(
          key: key,
          color: AppColor.white,
          gap: 64,
          top: CardTitle(
            title: Text(title, style: AppTextStyle.ownedTicket),
            description: Text(description, style: AppTextStyle.explainer),
          ),
          bottom: CardBottomRow(
            left: _TicketPrice(amount: amount, price: price),
          ),
          onTap: (context) {
            showModalBottomSheet(
              context: context,
              barrierColor: AppColor.scrim,
              backgroundColor: Colors.transparent,
              isDismissible: true,
              useRootNavigator: true,
              builder: (_) => _BuyTicketBottomModalSheet(
                productId: productId,
                title: title,
                amount: amount,
                price: price,
              ),
            );
          },
        );
}

class _TicketPrice extends StatelessWidget {
  const _TicketPrice({
    Key? key,
    required this.amount,
    required this.price,
  }) : super(key: key);

  final int amount;
  final int price;

  String get amountDisplayName =>
      amount != 1 ? '$amount tickets' : '$amount ticket';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(amountDisplayName, style: AppTextStyle.explainerDark),
        Text('$price,-', style: AppTextStyle.sectionTitle),
      ],
    );
  }
}

class _BuyTicketBottomModalSheet extends StatelessWidget {
  const _BuyTicketBottomModalSheet({
    required this.productId,
    required this.title,
    required this.amount,
    required this.price,
  });

  final int productId;
  final int amount;
  final int price;
  final String title;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Text('Confirm purchase', style: AppTextStyle.explainerBright),
          Text('Tap here to cancel', style: AppTextStyle.explainerBright),
          const Gap(12),
          Container(
            color: AppColor.background,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "You're buying $amount $title tickets",
                      style: AppTextStyle.explainerDark,
                    ),
                    const Gap(4),
                    Text(
                      'Pay $price,- with…',
                      style: AppTextStyle.price,
                    ),
                    const Gap(12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const RoundedButton(
                                text: 'Google Pay',
                                onPressed: null,
                              ),
                              Text(
                                'This feature is coming soon',
                                textAlign: TextAlign.center,
                                style: AppTextStyle.explainerSmall,
                              ),
                            ],
                          ),
                        ),
                        const Gap(8),
                        Expanded(
                          child: RoundedButton(
                            text: 'MobilePay',
                            onPressed: () async {
                              PurchaseOverlay.of(context).show(
                                InternalPaymentType.mobilePay,
                                Product(
                                  price: price,
                                  amount: amount,
                                  productName: title,
                                  id: productId,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

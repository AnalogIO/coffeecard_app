import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/features/product/presentation/functions.dart';
import 'package:coffeecard/features/product/product_model.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:flutter/material.dart';

class BuyTicketsCard extends StatefulWidget {
  final Product product;

  const BuyTicketsCard(this.product);

  @override
  State<BuyTicketsCard> createState() => _BuyTicketsCardState();
}

class _BuyTicketsCardState extends State<BuyTicketsCard> {
  Future<void> onTap(BuildContext context, Product product) {
    return buyModal(
      context: context,
      product: product,
      callback: (context, maybePayment) async {
        if (maybePayment?.status == PaymentStatus.completed) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final radius = BorderRadius.circular(24);

    return Material(
      color: AppColors.paper,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: () => onTap(context, product),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.crema,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.local_cafe_outlined,
                  color: AppColors.espresso,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: AppTextStyle.ui(17, weight: 600)),
                    if (product.description.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        product.description,
                        style: AppTextStyle.ui(13, color: AppColors.grounds),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      _amountDisplayName(product.amount),
                      style: AppTextStyle.receiptItemDate,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                Strings.price(product.price),
                style: AppTextStyle.ticketFigure.copyWith(
                  fontSize: 17,
                  color: AppColors.roast,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _amountDisplayName(int amount) =>
    '$amount ticket${amount != 1 ? 's' : ''}';

import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/design/glass_surface.dart';
import 'package:coffeecard/features/product/product_model.dart';
import 'package:coffeecard/features/purchase/domain/entities/internal_payment_type.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:coffeecard/features/purchase/presentation/widgets/purchase_overlay.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Floating sheet that confirms a purchase and pays with MobilePay.
class BuyTicketBottomModalSheet extends StatelessWidget {
  const BuyTicketBottomModalSheet({
    required this.product,
    required this.description,
  });

  final Product product;
  final String description;

  @override
  Widget build(BuildContext context) {
    final isFree = product.price == 0;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: GlassSurface(
        sheet: true,
        radius: 40,
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              Strings.confirmPurchase.toUpperCase(),
              style: AppTextStyle.ticketLabel,
            ),
            const Gap(8),
            Text(description, style: AppTextStyle.ownedTicket),
            const Gap(16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.paper,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      Strings.purchaseTotal,
                      style: AppTextStyle.ui(15, color: AppColors.groundsDark),
                    ),
                  ),
                  Text(
                    isFree ? Strings.free : Strings.price(product.price),
                    style: AppTextStyle.ticketFigure.copyWith(
                      fontSize: 20,
                      color: AppColors.roast,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),
            FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                backgroundColor: AppColors.espresso,
                foregroundColor: AppColors.cream,
                shape: const StadiumBorder(),
              ),
              onPressed: () async {
                final payment = await showPurchaseOverlay(
                  paymentType: InternalPaymentType.mobilePay,
                  product: product,
                  context: context,
                );
                if (!context.mounted) return;
                // Remove this bottom modal sheet.
                Navigator.pop<Payment>(context, payment);
              },
              child: Text(
                isFree
                    ? Strings.paymentConfirmationButtonRedeem
                    : Strings.payWithMobilePay,
                style: AppTextStyle.ui(16, weight: 600, color: AppColors.cream),
              ),
            ),
            const Gap(4),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: Text(
                Strings.buttonCancel,
                style: AppTextStyle.ui(
                  15,
                  weight: 500,
                  color: AppColors.groundsDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

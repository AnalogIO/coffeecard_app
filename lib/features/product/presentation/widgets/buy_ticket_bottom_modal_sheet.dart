import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/bottom_modal_sheet_helper.dart';
import 'package:coffeecard/core/widgets/components/rounded_button.dart';
import 'package:coffeecard/features/product/product_model.dart';
import 'package:coffeecard/features/purchase/domain/entities/internal_payment_type.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:coffeecard/features/purchase/presentation/widgets/purchase_overlay.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BuyTicketBottomModalSheet extends StatelessWidget {
  const BuyTicketBottomModalSheet({
    required this.product,
    required this.description,
  });

  final Product product;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        BottomModalSheetHelper(
          children: [
            Text(
              Strings.confirmPurchase,
              style: AppTextStyle.explainerBright,
            ),
            Text(
              Strings.tapHereToCancel,
              style: AppTextStyle.explainerBright,
            ),
          ],
        ),
        _ModalContent(product: product, description: description),
      ],
    );
  }
}

class _ModalContent extends StatelessWidget {
  const _ModalContent({required this.product, required this.description});

  final Product product;
  final String description;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                description,
                style: AppTextStyle.explainerDark,
              ),
              const Gap(4),
              Text(
                product.price != 0
                    ? Strings.paymentConfirmationBottomPurchase(product.price)
                    : Strings.paymentConfirmationButtonRedeem,
                style: AppTextStyle.price,
              ),
              const Gap(12),
              _BottomModalSheetButtonBar(product: product),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomModalSheetButtonBar extends StatefulWidget {
  const _BottomModalSheetButtonBar({required this.product});

  final Product product;

  @override
  State<_BottomModalSheetButtonBar> createState() =>
      _BottomModalSheetButtonBarState();
}

class _BottomModalSheetButtonBarState
    extends State<_BottomModalSheetButtonBar> {
  @override
  Widget build(BuildContext context) {
    final productPrice = widget.product.price;
    final productId = widget.product.id;
    final isFreeProduct = productPrice == 0;

    if (isFreeProduct) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BottomModalSheetButton(
            text: 'Redeem product',
            productId: productId,
            price: productPrice,
            onTap: () async {
              final payment = await showPurchaseOverlay(
                paymentType: InternalPaymentType.free,
                product: widget.product,
                context: context,
              );

              if (!mounted) return;
              // Remove this bottom modal sheet.
              Navigator.pop<Payment>(
                context,
                payment,
              );
            },
          ),
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BottomModalSheetButton(
          text: Strings.paymentOptionOther,
          productId: productId,
          price: productPrice,
          disabled: true,
          disabledText: Strings.paymentOptionOtherComingSoon,
        ),
        const Gap(8),
        _BottomModalSheetButton(
          text: Strings.paymentOptionMobilePay,
          productId: productId,
          price: productPrice,
          onTap: () async {
            final payment = await showPurchaseOverlay(
              paymentType: InternalPaymentType.mobilePay,
              product: widget.product,
              context: context,
            );

            if (!mounted) return;
            // Remove this bottom modal sheet.
            Navigator.pop<Payment>(
              context,
              payment,
            );
          },
        ),
      ],
    );
  }
}

class _BottomModalSheetButton extends StatelessWidget {
  const _BottomModalSheetButton({
    this.disabled = false,
    this.disabledText,
    required this.text,
    required this.productId,
    required this.price,
    this.onTap,
  });

  final bool disabled;
  final String? disabledText;
  final String text;
  final int productId;
  final int price;
  final void Function()? onTap;

  RoundedButton get _button => RoundedButton(text: text, onTap: onTap);

  Widget _withDisabledText(RoundedButton button, String disabledText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        button,
        Text(
          disabledText,
          textAlign: TextAlign.center,
          style: AppTextStyle.explainerSmall,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: (disabled && disabledText != null)
          ? _withDisabledText(_button, disabledText!)
          : _button,
    );
  }
}

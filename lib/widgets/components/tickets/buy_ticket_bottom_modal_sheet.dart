import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:coffeecard/widgets/components/purchase/purchase_overlay.dart';
import 'package:coffeecard/widgets/components/tickets/bottom_modal_sheet_helper.dart';
import 'package:coffeecard/widgets/components/tickets/rounded_button.dart';
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
    return Container(
      color: AppColor.background,
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
                Strings.paymentConfirmationBottom(product.price),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BottomModalSheetButton(
          text: Strings.paymentOptionOther,
          productId: widget.product.id,
          price: widget.product.price,
          disabled: true,
          disabledText: Strings.paymentOptionOtherComingSoon,
        ),
        const Gap(8),
        _BottomModalSheetButton(
          text: Strings.paymentOptionMobilePay,
          productId: widget.product.id,
          price: widget.product.price,
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

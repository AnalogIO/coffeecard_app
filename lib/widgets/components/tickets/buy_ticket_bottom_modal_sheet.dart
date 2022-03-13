import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:coffeecard/widgets/components/purchase/purchase_overlay.dart';
import 'package:coffeecard/widgets/components/tickets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BuyTicketBottomModalSheet extends StatelessWidget {
  const BuyTicketBottomModalSheet({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      // TODO: Possibily very expensive widget, look into alternatives?
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _ButtomModalSheetHelper(),
          _ModalContent(product: product),
        ],
      ),
    );
  }
}

class _ModalContent extends StatelessWidget {
  const _ModalContent({required this.product});

  final Product product;

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
                Strings.paymentConfirmationTop(product.amount, product.name),
                style: AppTextStyle.explainerDark,
              ),
              const Gap(4),
              Text(
                Strings.paymentConfirmationBottom(product.price),
                style: AppTextStyle.price,
              ),
              const Gap(12),
              _ButtonModalSheetButtonBar(product: product),
            ],
          ),
        ),
      ),
    );
  }
}

class _ButtonModalSheetButtonBar extends StatelessWidget {
  const _ButtonModalSheetButtonBar({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ButtomModalSheetButton(
          text: Strings.paymentOptionOther,
          productId: product.id,
          price: product.price,
          disabled: true,
          disabledText: Strings.paymentOptionOtherComingSoon,
        ),
        const Gap(8),
        _ButtomModalSheetButton(
          text: Strings.paymentOptionMobilePay,
          productId: product.id,
          price: product.price,
          onTap: () async => PurchaseOverlay.of(context)
              .show(InternalPaymentType.mobilePay, product),
        ),
      ],
    );
  }
}

class _ButtomModalSheetButton extends StatelessWidget {
  const _ButtomModalSheetButton({
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

class _ButtomModalSheetHelper extends StatefulWidget {
  const _ButtomModalSheetHelper();

  @override
  State<StatefulWidget> createState() => _ButtomModalSheetHelperState();
}

class _ButtomModalSheetHelperState extends State<_ButtomModalSheetHelper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return FadeTransition(
      opacity: _animation,
      child: GestureDetector(
        onTap: () => Navigator.of(context, rootNavigator: true).pop(),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Text(Strings.confirmPurchase, style: AppTextStyle.explainerBright),
            Text(Strings.tapHereToCancel, style: AppTextStyle.explainerBright),
            const Gap(12),
          ],
        ),
      ),
    );
  }
}

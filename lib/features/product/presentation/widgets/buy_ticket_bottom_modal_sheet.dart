import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/bottom_modal_sheet_helper.dart';
import 'package:coffeecard/core/widgets/components/rounded_button.dart';
import 'package:coffeecard/features/product/menu_item_model.dart';
import 'package:coffeecard/features/product/product_model.dart';
import 'package:coffeecard/features/purchase/domain/entities/internal_payment_type.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:coffeecard/features/purchase/presentation/widgets/purchase_overlay.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
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
  late Option<MenuItem> _selectedMenuItem =
      widget.product.eligibleMenuItems.head;

  @override
  Widget build(BuildContext context) {
    final productPrice = widget.product.price;
    final productId = widget.product.id;
    final isFreeProduct = productPrice == 0;

    final dropdownItems = widget.product.eligibleMenuItems
        .map((mi) => DropdownMenuItem(value: mi, child: Text(mi.name)))
        .toList();

    if (isFreeProduct) {
      return Column(
        children: [
          if (widget.product.eligibleMenuItems.length > 1)
            Row(
              children: [
                Expanded(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      border: BorderDirectional(
                        bottom: BorderSide(
                          color: AppColors.secondary,
                          width: 2,
                        ),
                      ),
                    ),
                    child: DropdownButton<MenuItem>(
                      hint: const Text('Select a product...'),
                      isExpanded: true,
                      value: _selectedMenuItem.toNullable(),
                      items: dropdownItems,
                      onChanged: (newItem) {
                        if (newItem != null) {
                          setState(() => _selectedMenuItem = Some(newItem));
                        }
                      },
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      focusColor: AppColors.primary,
                      underline: const SizedBox.shrink(),
                      dropdownColor: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          Row(
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

                  if (!context.mounted) return;
                  // Remove this bottom modal sheet.
                  Navigator.pop<(Payment?, Option<MenuItem>)>(
                    context,
                    (payment, _selectedMenuItem),
                  );
                },
              ),
            ],
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

            if (!context.mounted) return;
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

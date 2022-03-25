import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/environment/environment_cubit.dart';
import 'package:coffeecard/cubits/receipt/receipt_cubit.dart';
import 'package:coffeecard/cubits/tickets/tickets_cubit.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/utils/responsive.dart';
import 'package:coffeecard/widgets/components/card.dart';
import 'package:coffeecard/widgets/components/dialog.dart';
import 'package:coffeecard/widgets/components/purchase/purchase.dart';
import 'package:coffeecard/widgets/components/receipt/receipt_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class BuyTicketsCard extends StatefulWidget {
  const BuyTicketsCard({required this.product});
  final Product product;

  @override
  State<BuyTicketsCard> createState() => _BuyTicketsCardState();
}

class _BuyTicketsCardState extends State<BuyTicketsCard> {
  @override
  Widget build(BuildContext context) {
    return CardBase(
      color: AppColor.white,
      gap: deviceIsSmall(context) ? 48 : 64,
      top: CardTitle(
        title: Text(widget.product.name, style: AppTextStyle.ownedTicket),
        description:
            Text(widget.product.description, style: AppTextStyle.explainer),
      ),
      bottom: CardBottomRow(
        left: _TicketPrice(
          amount: widget.product.amount,
          price: widget.product.price,
        ),
      ),
      onTap: (context) async {
        final either = await startPayment(
          context: context,
          product: widget.product,
        );

        if (either == null) {
          throw Exception('Purchase route popped without a return value');
        }

        if (!mounted) return;

        if (either.isLeft) {
          // API error during payment
          return appDialog(
            context: context,
            title: Strings.purchaseErrorTitle,
            children: [
              const Text(Strings.purchaseErrorMessage),
              const Gap(12),
              Text(either.left.errorMessage),
            ],
            actions: [
              TextButton(
                onPressed: () => closeAppDialog(context),
                child: const Text(Strings.buttonOK),
              )
            ],
            dismissible: true,
          );
        } else {
          // No API error during payment
          final maybePayment = either.right;

          if (maybePayment != null) {
            // Accepted payment

            context.read<TicketsCubit>().getTickets();
            context.read<ReceiptCubit>().fetchReceipts();
            Navigator.of(context).popUntil((route) => route.isFirst);

            final payment = maybePayment;
            final env = context.read<EnvironmentCubit>().state;
            final receipt = Receipt(
              timeUsed: payment.purchaseTime,
              amountPurchased: widget.product.amount,
              transactionType: TransactionType.purchase,
              productName: widget.product.name,
              // TODO: change the productName to use the name from
              //       the payment instead, once the backend returns this
              price: payment.price,
              id: widget.product.id,
            );
            final isTestEnvironment =
                env is EnvironmentLoaded && env.isTestEnvironment;

            ReceiptOverlay.of(context).show(
              receipt: receipt,
              isTestEnvironment: isTestEnvironment,
            );
          } else {
            // Rejected payment
            appDialog(
              context: context,
              title: Strings.purchaseRejectedOrCanceled,
              children: [const Text(Strings.purchaseRejectedOrCanceledMessage)],
              actions: [
                TextButton(
                  onPressed: () => closeAppDialog(context),
                  child: const Text(Strings.buttonOK),
                )
              ],
              dismissible: true,
            );
          }
        }
      },
    );
  }
}

class _TicketPrice extends StatelessWidget {
  const _TicketPrice({required this.amount, required this.price});

  final int amount;
  final int price;

  String get _amountDisplayName {
    final s = amount != 1 ? 's' : '';
    return '$amount ticket$s';
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: deviceIsSmall(context) ? Axis.horizontal : Axis.vertical,
      verticalDirection: deviceIsSmall(context)
          ? VerticalDirection.down
          : VerticalDirection.up,
      crossAxisAlignment: deviceIsSmall(context)
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.stretch,
      children: [
        Text('$price,-', style: AppTextStyle.sectionTitle),
        if (deviceIsSmall(context)) const Gap(8),
        Text(_amountDisplayName, style: AppTextStyle.explainerDark),
      ],
    );
  }
}

import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/environment/environment_cubit.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/utils/responsive.dart';
import 'package:coffeecard/widgets/components/card.dart';
import 'package:coffeecard/widgets/components/receipt/receipt_overlay.dart';
import 'package:coffeecard/widgets/components/tickets/buy_ticket_bottom_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class BuyTicketsCard extends StatelessWidget {
  final Product product;

  const BuyTicketsCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return CardBase(
      color: AppColor.white,
      gap: deviceIsSmall(context) ? 48 : 64,
      top: CardTitle(
        title: Text(product.name, style: AppTextStyle.ownedTicket),
        description: Text(product.description, style: AppTextStyle.explainer),
      ),
      bottom: CardBottomRow(
        left: _TicketPrice(amount: product.amount, price: product.price),
      ),
      onTap: (context) async {
        final payment = await showModalBottomSheet<Payment>(
          context: context,
          barrierColor: AppColor.scrim,
          backgroundColor: Colors.transparent,
          isDismissible: true,
          useRootNavigator: true,
          builder: (_) => BuyTicketBottomModalSheet(product: product),
        );
        //ignore: use_build_context_synchronously
        if (payment != null && payment.status == PaymentStatus.completed) {
          //ignore: use_build_context_synchronously
          Navigator.pop(context); //Sends the user back to the home-screen

          //ignore: use_build_context_synchronously
          final env = context.read<EnvironmentCubit>().state;
          //ignore: use_build_context_synchronously
          ReceiptOverlay.of(context).show(
            receipt: Receipt(
              timeUsed: payment.purchaseTime,
              amountPurchased: product.amount,
              transactionType: TransactionType.purchase,
              productName: payment.productName!,
              price: payment.price,
              id: product.id,
            ),
            isTestEnvironment:
                env is EnvironmentLoaded && env.isTestEnvironment,
          );
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

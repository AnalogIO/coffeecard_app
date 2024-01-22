import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/features/environment/domain/entities/environment.dart';
import 'package:coffeecard/features/environment/presentation/cubit/environment_cubit.dart';
import 'package:coffeecard/features/product/presentation/widgets/buy_ticket_bottom_modal_sheet.dart';
import 'package:coffeecard/features/product/product_model.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:coffeecard/features/receipt/presentation/cubit/receipt_cubit.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/receipt_overlay.dart';
import 'package:coffeecard/features/ticket/presentation/cubit/tickets_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> buyModal({
  required BuildContext context,
  required Product product,

  /// Callback that will be run after the purchase modal is closed, but before
  /// the receipt overlay is shown.
  ///
  /// [payment] will be null if the purchase was cancelled.
  required Future<void> Function(BuildContext, Payment?) callback,
}) async {
  // Find the correct text to show in the scrim.
  const free = 0;
  const single = 1;
  final scrimText = switch ((product.price, product.amount)) {
    (free, single) => Strings.paymentConfirmationTopFreeSingle(product.name),
    (_, single) => Strings.paymentConfirmationTopSingle(product.name),
    _ => Strings.paymentConfirmationTopTickets(product.amount, product.name),
  };

  // Create a task that will open the purchase modal and wait for the result.
  final maybePayment = await showModalBottomSheet<Payment>(
    context: context,
    barrierColor: AppColors.scrim,
    backgroundColor: Colors.transparent,
    useRootNavigator: true,
    builder: (_) => BuyTicketBottomModalSheet(
      product: product,
      description: scrimText,
    ),
  );

  if (!context.mounted) return;

  // Run the callback with the result of the purchase modal.
  await callback(context, maybePayment);

  if (!context.mounted) return;

  // Show the receipt overlay if the payment was successful.
  if (maybePayment?.status == PaymentStatus.completed) {
    return _afterPurchaseModal(context, maybePayment!, product);
  }
}

Future<void> _afterPurchaseModal(
  BuildContext context,
  Payment payment,
  Product product,
) async {
  final envState = context.read<EnvironmentCubit>().state;
  final singleTicketPurchase = product.amount == 1;

  final ticketsCubit = context.read<TicketsCubit>();
  final receiptCubit = context.read<ReceiptCubit>();

  if (singleTicketPurchase) {
    await ticketsCubit.useTicket(
      product.id,
      product.eligibleMenuItems.first.id,
    );
  } else {
    ticketsCubit.getTickets();
    ReceiptOverlay.show(
      context: context,
      isTestEnvironment: envState is EnvironmentLoaded && envState.env.isTest,
      status: Strings.purchased,
      productName: payment.productName,
      timeUsed: payment.purchaseTime,
    ).ignore();
  }
  await receiptCubit.fetchReceipts();
}

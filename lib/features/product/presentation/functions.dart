import 'package:coffeecard/core/firebase_analytics_event_logging.dart';
import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/features/environment/domain/entities/environment.dart';
import 'package:coffeecard/features/environment/presentation/cubit/environment_cubit.dart';
import 'package:coffeecard/features/product/domain/entities/product.dart';
import 'package:coffeecard/features/product/presentation/pages/buy_tickets_page.dart';
import 'package:coffeecard/features/product/presentation/widgets/buy_ticket_bottom_modal_sheet.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:coffeecard/features/receipt/presentation/cubit/receipt_cubit.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/receipt_overlay.dart';
import 'package:coffeecard/features/ticket/presentation/cubit/tickets_cubit.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> buyModal({
  required BuildContext context,
  required Product product,

  /// Callback that will be run after the purchase modal is closed, but before
  /// the receipt overlay is shown.
  required Future<void> Function(BuildContext, Payment?) callback,
}) async {
  sl<FirebaseAnalyticsEventLogging>().selectProductFromListEvent(
    product,
    BuyTicketsPage.fbAnalyticsListId,
    BuyTicketsPage.fbAnalyticsListName,
  );
  sl<FirebaseAnalyticsEventLogging>().viewProductEvent(product);

  final scrimText = (product.price == 0)
      ? Strings.paymentConfirmationTopSingle(product.amount, product.name)
      : Strings.paymentConfirmationTopTickets(product.amount, product.name);

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
  return afterPurchaseModal(context, maybePayment);
}

Future<void> afterPurchaseModal(BuildContext context, Payment? payment) async {
  // Don't do anything if the payment is null or not completed.
  if (payment == null || payment.status != PaymentStatus.completed) {
    return;
  }

  final envState = context.read<EnvironmentCubit>().state;

  final updateTicketsRequest = context.read<TicketsCubit>().getTickets();
  final updateReceiptsRequest = context.read<ReceiptCubit>().fetchReceipts();

  ReceiptOverlay.show(
    context: context,
    isTestEnvironment: envState is EnvironmentLoaded && envState.env.isTest,
    status: Strings.purchased,
    productName: payment.productName,
    timeUsed: payment.purchaseTime,
  ).ignore();

  // TODO: Explain why we need to await here.
  await updateTicketsRequest;
  await updateReceiptsRequest;
}

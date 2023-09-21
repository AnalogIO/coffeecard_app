import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/features/environment/domain/entities/environment.dart';
import 'package:coffeecard/features/environment/presentation/cubit/environment_cubit.dart';
import 'package:coffeecard/features/product/domain/entities/product.dart';
import 'package:coffeecard/features/product/presentation/pages/buy_single_drink_page.dart';
import 'package:coffeecard/features/product/presentation/pages/buy_tickets_page.dart';
import 'package:coffeecard/features/product/presentation/widgets/buy_ticket_bottom_modal_sheet.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:coffeecard/features/receipt/presentation/cubit/receipt_cubit.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/receipt_overlay.dart';
import 'package:coffeecard/features/ticket/presentation/cubit/tickets_cubit.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/firebase_analytics_event_logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> afterPurchaseModal(Payment? payment, BuildContext context) async {
  // Don't do anything if the payment is null or not completed.
  if (payment == null || payment.status != PaymentStatus.completed) {
    return;
  }

  // Payment is completed: Send the user back to the home-screen.
  Navigator.pop(context);

  final envState = context.read<EnvironmentCubit>().state;

  final updateTicketsRequest = context.read<TicketsCubit>().getTickets();
  final updateReceiptsRequest = context.read<ReceiptCubit>().fetchReceipts();

  ReceiptOverlay.of(context).show(
    isTestEnvironment: envState is EnvironmentLoaded && envState.env.isTest,
    status: Strings.purchased,
    productName: payment.productName,
    timeUsed: payment.purchaseTime,
  );

  // TODO: Explain why we need to await here.
  await updateTicketsRequest;
  await updateReceiptsRequest;
}

Future<Payment?> buyTicketsModal(BuildContext context, Product product) {
  sl<FirebaseAnalyticsEventLogging>().selectProductFromListEvent(
    product,
    BuyTicketsPage.fbAnalyticsListId,
    BuyTicketsPage.fbAnalyticsListName,
  );
  sl<FirebaseAnalyticsEventLogging>().viewProductEvent(product);

  return showModalBottomSheet<Payment>(
    context: context,
    barrierColor: AppColor.scrim,
    backgroundColor: Colors.transparent,
    useRootNavigator: true,
    builder: (_) => BuyTicketBottomModalSheet(
      product: product,
      description:
          Strings.paymentConfirmationTopTickets(product.amount, product.name),
    ),
  );
}

Future<Payment?> buyNSwipeModal(BuildContext context, Product product) {
  {
    sl<FirebaseAnalyticsEventLogging>().selectProductFromListEvent(
      product,
      BuySingleDrinkPage.fbAnalyticsListId,
      BuySingleDrinkPage.fbAnalyticsListName,
    );
    sl<FirebaseAnalyticsEventLogging>().viewProductEvent(
      product,
    );

    return showModalBottomSheet<Payment>(
      context: context,
      barrierColor: AppColor.scrim,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (_) => BuyTicketBottomModalSheet(
        product: product,
        description: Strings.paymentConfirmationTopSingle(
          product.amount,
          product.name,
        ),
      ),
    );
  }
}

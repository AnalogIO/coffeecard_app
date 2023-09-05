import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/features/environment/domain/entities/environment.dart';
import 'package:coffeecard/features/environment/presentation/cubit/environment_cubit.dart';
import 'package:coffeecard/features/product/domain/entities/product.dart';
import 'package:coffeecard/features/product/presentation/cubit/product_cubit.dart';
import 'package:coffeecard/features/product/presentation/pages/buy_single_drink_page.dart';
import 'package:coffeecard/features/product/presentation/widgets/buy_ticket_bottom_modal_sheet.dart';
import 'package:coffeecard/features/product/presentation/widgets/buy_tickets_card.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:coffeecard/features/receipt/presentation/cubit/receipt_cubit.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/receipt_overlay.dart';
import 'package:coffeecard/features/ticket/presentation/cubit/tickets_cubit.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/firebase_analytics_event_logging.dart';
import 'package:coffeecard/widgets/components/error_section.dart';
import 'package:coffeecard/widgets/components/helpers/grid.dart';
import 'package:coffeecard/widgets/components/loading.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyTicketsPage extends StatefulWidget {
  const BuyTicketsPage();

  static const String fbAnalyticsListId = 'buy_tickets';
  static const String fbAnalyticsListName = Strings.buyTickets;

  static Route get route =>
      MaterialPageRoute(builder: (_) => const BuyTicketsPage());

  @override
  State<BuyTicketsPage> createState() => _BuyTicketsPageState();
}

class _BuyTicketsPageState extends State<BuyTicketsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductCubit>()..getProducts(),
      child: AppScaffold.withTitle(
        title: Strings.buyTickets,
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const Loading(loading: true);
            } else if (state is ProductsLoaded) {
              sl<FirebaseAnalyticsEventLogging>().viewProductsListEvent(
                state.ticketProducts,
                BuyTicketsPage.fbAnalyticsListId,
                BuyTicketsPage.fbAnalyticsListName,
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Grid(
                  gap: GridGap.normal,
                  gapSmall: GridGap.tight,
                  singleColumnOnSmallDevice: true,
                  children: state.ticketProducts
                      .map(BuyTicketsCard.multiple)
                      .toList(),
                ),
              );
            } else if (state is ProductsError) {
              return ErrorSection(
                center: true,
                error: state.error,
                retry: context.read<ProductCubit>().getProducts,
              );
            }

            throw ArgumentError(this);
          },
        ),
      ),
    );
  }

  Future<void> onTap(BuildContext context, Product product) async {
    final payment = await buyTicketsModal(context, product);

    if (!mounted) return;

    if (payment != null && payment.status == PaymentStatus.completed) {
      // Send the user back to the home-screen.
      Navigator.pop(context);

      final envState = context.read<EnvironmentCubit>().state;

      final updateTicketsRequest = context.read<TicketsCubit>().getTickets();
      final updateReceiptsRequest =
          context.read<ReceiptCubit>().fetchReceipts();

      ReceiptOverlay.of(context).show(
        isTestEnvironment: envState is EnvironmentLoaded && envState.env.isTest,
        status: Strings.purchased,
        productName: payment.productName,
        timeUsed: payment.purchaseTime,
      );
      await updateTicketsRequest;
      await updateReceiptsRequest;
    }
  }
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

// FIXME move

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

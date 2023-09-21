import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/app_colors.dart';
import 'package:coffeecard/features/product/domain/entities/product.dart';
import 'package:coffeecard/features/product/presentation/cubit/product_cubit.dart';
import 'package:coffeecard/features/product/presentation/widgets/buy_ticket_bottom_modal_sheet.dart';
import 'package:coffeecard/features/product/presentation/widgets/buy_tickets_card.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:coffeecard/features/receipt/presentation/cubit/receipt_cubit.dart';
import 'package:coffeecard/features/ticket/presentation/cubit/tickets_cubit.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/firebase_analytics_event_logging.dart';
import 'package:coffeecard/widgets/components/error_section.dart';
import 'package:coffeecard/widgets/components/helpers/grid.dart';
import 'package:coffeecard/widgets/components/loading.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuySingleDrinkPage extends StatelessWidget {
  const BuySingleDrinkPage();

  static const String _fbAnalyticsListId = 'buy_one_drink';
  static const String _fbAnalyticsListName = Strings.buyOneDrink;

  static Route get route =>
      MaterialPageRoute(builder: (_) => const BuySingleDrinkPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProductCubit>()..getProducts(),
      child: AppScaffold.withTitle(
        title: Strings.buyOneDrink,
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductsLoading) {
              return const Loading(loading: true);
            } else if (state is ProductsLoaded) {
              sl<FirebaseAnalyticsEventLogging>().viewProductsListEvent(
                state.singleDrinkProducts,
                _fbAnalyticsListId,
                _fbAnalyticsListName,
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Grid(
                  gap: GridGap.normal,
                  gapSmall: GridGap.tight,
                  singleColumnOnSmallDevice: true,
                  children: state.singleDrinkProducts
                      .map(
                        (product) => BuyTicketsCard(
                          product: product,
                          onTap: buyNSwipeModal,
                        ),
                      )
                      .toList(),
                ),
              );
            } else if (state is ProductsError) {
              return ErrorSection(
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

  Future<void> buyNSwipeModal(
    BuildContext context,
    Product product,
    State state,
  ) async {
    {
      sl<FirebaseAnalyticsEventLogging>().selectProductFromListEvent(
        product,
        _fbAnalyticsListId,
        _fbAnalyticsListName,
      );
      sl<FirebaseAnalyticsEventLogging>().viewProductEvent(
        product,
      );

      final payment = await showModalBottomSheet<Payment>(
        context: context,
        barrierColor: AppColors.scrim,
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
      if (!state.mounted) return;
      if (payment != null && payment.status == PaymentStatus.completed) {
        // Send the user back to the home-screen
        Navigator.pop(context);

        final ticketCubit = context.read<TicketsCubit>();
        final receiptCubit = context.read<ReceiptCubit>();
        await ticketCubit.useTicket(product.id);
        await receiptCubit.fetchReceipts();
      }
    }
  }
}

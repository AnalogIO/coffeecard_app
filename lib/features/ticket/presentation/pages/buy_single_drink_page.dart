import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/cubits/products/products_cubit.dart';
import 'package:coffeecard/cubits/receipt/receipt_cubit.dart';
import 'package:coffeecard/data/repositories/v1/product_repository.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/features/ticket/presentation/cubit/tickets_cubit.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/firebase_analytics_event_logging.dart';
import 'package:coffeecard/widgets/components/error_section.dart';
import 'package:coffeecard/widgets/components/helpers/grid.dart';
import 'package:coffeecard/widgets/components/loading.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/tickets/buy_ticket_bottom_modal_sheet.dart';
import 'package:coffeecard/widgets/components/tickets/buy_tickets_card.dart';
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
      create: (context) =>
          ProductsCubit(sl.get<ProductRepository>())..getProducts(),
      child: AppScaffold.withTitle(
        title: Strings.buyOneDrink,
        body: BlocBuilder<ProductsCubit, ProductsState>(
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
                retry: context.read<ProductsCubit>().getProducts,
              );
            }

            throw MatchCaseIncompleteException(this);
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
        _fbAnalyticsListId,
        _fbAnalyticsListName,
      );

      final payment = await showModalBottomSheet<Payment>(
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
      if (!state.mounted) return;
      if (payment != null && payment.status == PaymentStatus.completed) {
        // Send the user back to the home-screen
        Navigator.pop(context);

        context.read<TicketsCubit>().useTicket(product.id);
        context.read<ReceiptCubit>().fetchReceipts();
      }
    }
  }
}

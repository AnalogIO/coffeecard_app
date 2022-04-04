import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/cubits/products/products_cubit.dart';
import 'package:coffeecard/cubits/receipt/receipt_cubit.dart';
import 'package:coffeecard/cubits/tickets/tickets_cubit.dart';
import 'package:coffeecard/data/repositories/v1/product_repository.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/helpers/grid.dart';
import 'package:coffeecard/widgets/components/loading.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/tickets/buy_ticket_bottom_modal_sheet.dart';
import 'package:coffeecard/widgets/components/tickets/buy_tickets_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuySingleDrinkPage extends StatelessWidget {
  const BuySingleDrinkPage();

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
              // FIXME handle error
              return const Text('error');
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
      //TODO change this to just use a single endpoint, once the backend supports it
      final payment = await showModalBottomSheet<Payment>(
        context: context,
        barrierColor: AppColor.scrim,
        backgroundColor: Colors.transparent,
        isDismissible: true,
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
        Navigator.pop(context); //Sends the user back to the home-screen

        await sl<TicketsCubit>().useTicket(product.id);
        await sl<ReceiptCubit>().fetchReceipts();
      }
    }
  }
}

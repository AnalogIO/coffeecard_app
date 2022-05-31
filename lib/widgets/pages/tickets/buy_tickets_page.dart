import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/cubits/environment/environment_cubit.dart';
import 'package:coffeecard/cubits/products/products_cubit.dart';
import 'package:coffeecard/cubits/receipt/receipt_cubit.dart';
import 'package:coffeecard/cubits/tickets/tickets_cubit.dart';
import 'package:coffeecard/data/repositories/v1/product_repository.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/purchase/payment_status.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/error_section.dart';
import 'package:coffeecard/widgets/components/helpers/grid.dart';
import 'package:coffeecard/widgets/components/loading.dart';
import 'package:coffeecard/widgets/components/receipt/receipt_overlay.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/tickets/buy_ticket_bottom_modal_sheet.dart';
import 'package:coffeecard/widgets/components/tickets/buy_tickets_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuyTicketsPage extends StatelessWidget {
  const BuyTicketsPage();

  static Route get route =>
      MaterialPageRoute(builder: (_) => const BuyTicketsPage());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductsCubit(sl.get<ProductRepository>())..getProducts(),
      child: AppScaffold.withTitle(
        title: Strings.buyTickets,
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
                  children: state.ticketProducts
                      .map(
                        (product) => BuyTicketsCard(
                          product: product,
                          onTap: buyTicketsModal,
                        ),
                      )
                      .toList(),
                ),
              );
            } else if (state is ProductsError) {
              return ErrorSection(
                center: true,
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

  Future<void> buyTicketsModal(
    BuildContext context,
    Product product,
    State state,
  ) async {
    {
      final payment = await showModalBottomSheet<Payment>(
        context: context,
        barrierColor: AppColor.scrim,
        backgroundColor: Colors.transparent,
        isDismissible: true,
        useRootNavigator: true,
        builder: (_) => BuyTicketBottomModalSheet(
          product: product,
          description: Strings.paymentConfirmationTopTickets(
            product.amount,
            product.name,
          ),
        ),
      );
      if (!state.mounted) return;
      if (payment != null && payment.status == PaymentStatus.completed) {
        // Send the user back to the home-screen.
        Navigator.pop(context);

        final env = context.read<EnvironmentCubit>().state;

        final updateTicketsRequest = context.read<TicketsCubit>().getTickets();
        final updateReceiptsRequest =
            context.read<ReceiptCubit>().fetchReceipts();

        ReceiptOverlay.of(context).show(
          receipt: Receipt(
            timeUsed: payment.purchaseTime,
            amountPurchased: product.amount,
            transactionType: TransactionType.purchase,
            productName: payment.productName,
            price: payment.price,
            id: product.id,
          ),
          isTestEnvironment: env is EnvironmentLoaded && env.isTestEnvironment,
        );
        await updateTicketsRequest;
        await updateReceiptsRequest;
      }
    }
  }
}

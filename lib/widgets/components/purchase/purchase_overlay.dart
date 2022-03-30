import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/cubits/purchase/purchase_cubit.dart';
import 'package:coffeecard/cubits/receipt/receipt_cubit.dart';
import 'package:coffeecard/cubits/tickets/tickets_cubit.dart';
import 'package:coffeecard/models/purchase/payment.dart';
import 'package:coffeecard/models/ticket/product.dart';
import 'package:coffeecard/payment/payment_handler.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/purchase/purchase_process.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseOverlay {
  final BuildContext _context;

  Future<Payment?> show(
    InternalPaymentType paymentType,
    Product product,
  ) async {
    return showDialog<Payment>(
      context: _context,
      barrierColor: AppColor.scrim,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (_) {
        return WillPopScope(
          // Will prevent Android back button from closing overlay.
          onWillPop: () async => false,
          child: BlocProvider(
            create: (context) => PurchaseCubit(
              paymentHandler: PaymentHandler(paymentType),
              product: product,
            ),
            child: BlocListener<PurchaseCubit, PurchaseState>(
              listener: (context, state) async {
                if (state is PurchaseCompleted) {
                  final payment = state.payment;
                  payment.productName =
                      product.name; //TODO Receive this from backend
                  Navigator.pop<Payment>(context, payment);

                  //TODO Consider if these calls should be moved elsewhere, e.g. inside the purchase cubit
                  final ticketCubit = sl.get<TicketsCubit>();
                  final updateTicketsRequest = ticketCubit.getTickets();
                  final receiptCubit = sl.get<ReceiptCubit>();
                  final updateReceiptsRequest = receiptCubit.fetchReceipts();

                  await updateTicketsRequest;
                  await updateReceiptsRequest;
                }
              },
              child: const PurchaseProcess(),
            ),
          ),
        );
      },
    );
  }

  PurchaseOverlay.__create(this._context);

  factory PurchaseOverlay.of(BuildContext context) {
    return PurchaseOverlay.__create(context);
  }
}

import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/cubits/purchase/purchase_cubit.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/widgets/components/purchase/purchase_process_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseProcess extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PurchaseProcessState();
}

class _PurchaseProcessState extends State<PurchaseProcess>
    with WidgetsBindingObserver {
  AppLifecycleState? _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<PurchaseCubit, PurchaseState>(
            builder: (context, state) {
              final String title;
              final cubit = context.read<PurchaseCubit>();
              if (_notification == AppLifecycleState.resumed) {
                cubit.verifyPurchase();
              }
              if (state is PurchaseInitial) {
                //TODO move all relevant strings to the strings.dart file
                //Not related to previous check, hence a separate if statement
                title = 'Talking with payment provider';
                cubit.payWithMobilePay();
                return makeCard('Talking with payment provider');
              } else if (state is PurchaseProcessing ||
                  state is PurchaseStarted) {
                return makeCard('Talking with payment provider');
              } else if (state is PurchaseVerifying) {
                return makeCard('Completing purchase');
              } else if (state is PurchaseCompleted) {
                return makeCard('Success');
              } else if (state is PurchasePaymentRejected) {
                //FIXME: make tappable (tap to dismiss)
                return makeCard(
                  'Payment rejected or canceled',
                  bottomWidget: const Text(
                    'The payment was rejected or cancelled. No tickets have been added to your account',
                  ),
                );
              } else if (state is PurchaseError) {
                return makeCard('PurchaseApiError');
              } else {
                //FIXME: message
                throw MatchCaseIncompleteException('oops');
              }
            },
          ),
        ],
      ),
    );
  }

  PurchaseProcessCard makeCard(String title, {Widget? bottomWidget}) {
    return PurchaseProcessCard(
      //TODO add more styling
      title: title,
      bottomWidget: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: bottomWidget ??
            const Center(
              child: CircularProgressIndicator(color: AppColor.primary),
            ),
      ),
    );
  }
}

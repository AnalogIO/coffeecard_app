import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/cubits/purchase/purchase_cubit.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
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
              final cubit = context.read<PurchaseCubit>();
              if (_notification == AppLifecycleState.resumed) {
                cubit.verifyPurchase();
              }
              if (state is PurchaseInitial) {
                //TODO move all relevant strings to the strings.dart file
                //Not related to previous check, hence a separate if statement
                cubit.payWithMobilePay();
                return makeDialog('Talking with payment provider');
              } else if (state is PurchaseProcessing ||
                  state is PurchaseStarted) {
                return makeDialog('Talking with payment provider');
              } else if (state is PurchaseVerifying) {
                return makeDialog('Completing purchase');
              } else if (state is PurchaseCompleted) {
                return makeDialog('Success');
              } else if (state is PurchasePaymentRejected) {
                return makeDialog(
                  'Payment rejected or canceled',
                  content: const Text(
                    'The payment was rejected or cancelled. No tickets have been added to your account',
                  ),
                );
              } else if (state is PurchaseError) {
                return makeDialog(
                  "Uh oh, we couldn't complete that purchase",
                  content: Text(state.message),
                );
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

  StatelessWidget makeDialog(String title, {Widget? content}) {
    return content != null
        ? AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(title),
            content: content,
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        : SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(title),
            children: [
              Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(color: AppColor.primary),
                  ),
                ],
              )
            ],
          );
  }
}

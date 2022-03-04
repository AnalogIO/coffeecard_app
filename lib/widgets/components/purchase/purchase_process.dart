import 'package:coffeecard/base/strings.dart';
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
                //Not related to previous check, hence a separate if statement
                cubit.payWithMobilePay();
                return makeDialog(Strings.purchaseTalking);
              } else if (state is PurchaseProcessing ||
                  state is PurchaseStarted) {
                return makeDialog(Strings.purchaseTalking);
              } else if (state is PurchaseVerifying) {
                return makeDialog(Strings.purchaseCompleting);
              } else if (state is PurchaseCompleted) {
                return makeDialog(Strings.purchaseSuccess);
              } else if (state is PurchasePaymentRejected) {
                return makeDialog(
                  Strings.purchaseRejectedOrCanceled,
                  content: const Text(
                    Strings.purchaseRejectedOrCanceledMessage,
                  ),
                );
              } else if (state is PurchaseError) {
                return makeDialog(
                  Strings.purchaseError,
                  content: Text(state.message),
                );
              } else {
                //FIXME: message
                throw MatchCaseIncompleteException(
                  'Unmatched state for PurchaseState',
                );
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
                child: const Text(Strings.purchaseErrorOk),
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

import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/features/purchase/presentation/cubit/purchase_cubit.dart';
import 'package:coffeecard/features/purchase/presentation/widgets/error_dialog.dart';
import 'package:coffeecard/features/purchase/presentation/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PurchaseProcess extends StatefulWidget {
  const PurchaseProcess();
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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    final _ = WidgetsBinding.instance.removeObserver(this);
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
                cubit.pay();
                return const LoadingDialog(
                  title: Strings.purchaseTalking,
                );
              } else if (state is PurchaseProcessing ||
                  state is PurchaseStarted) {
                return const LoadingDialog(
                  title: Strings.purchaseTalking,
                );
              } else if (state is PurchaseVerifying) {
                return const LoadingDialog(
                  title: Strings.purchaseCompleting,
                );
              } else if (state is PurchaseCompleted) {
                return const LoadingDialog(
                  title: Strings.purchaseSuccess,
                );
              } else if (state is PurchasePaymentRejected) {
                return const ErrorDialog(
                  title: Strings.purchaseRejectedOrCanceled,
                  child: Text(
                    Strings.purchaseRejectedOrCanceledMessage,
                  ),
                );
              } else if (state is PurchaseError) {
                return ErrorDialog(
                  title: Strings.purchaseError,
                  child: Text(state.message),
                );
              } else if (state is PurchaseTimeout) {
                return const ErrorDialog(
                  title: Strings.purchaseTimeout,
                  child: Text(Strings.purchaseTimeoutMessage),
                );
              }

              throw ArgumentError(this);
            },
          ),
        ],
      ),
    );
  }
}

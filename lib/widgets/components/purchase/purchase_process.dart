import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/cubits/purchase/purchase_cubit.dart';
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
              } else if (state is PurchaseProcessing ||
                  state is PurchaseStarted) {
                title = 'Talking with payment provider';
              } else if (state is PurchaseVerifying) {
                title = 'Completing purchase';
              } else if (state is PurchaseCompleted) {
                title = 'Success';
              } else {
                title = 'This should not have happened';
              }
              return PurchaseProcessCard(
                //TODO add more styling
                title: title,
                bottomWidget: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child:
                            CircularProgressIndicator(color: AppColor.primary),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

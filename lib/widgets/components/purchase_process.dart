import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/widgets/components/purchase_process_card.dart';
import 'package:flutter/material.dart';

class PurchaseProcess extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PurchaseProcessState();
}

class _PurchaseProcessState extends State<PurchaseProcess> with WidgetsBindingObserver {
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
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    print(routeInformation.location);
    return didPushRoute(routeInformation.location!);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PurchaseProcessCard(
            title: _notification == AppLifecycleState.resumed ? 'Finalizing purchase' : 'Summoning MobilePay',
            bottomWidget: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: AppColor.primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

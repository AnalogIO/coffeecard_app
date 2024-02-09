import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/helpers/responsive.dart';
import 'package:coffeecard/core/widgets/components/scaffold.dart';
import 'package:coffeecard/features/environment.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/receipt_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewReceiptPage extends StatelessWidget {
  const ViewReceiptPage({required this.receipt});

  final SwipeReceipt receipt;

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.singleReceiptPageTitle,
      body: Padding(
        padding: EdgeInsets.all(deviceIsSmall(context) ? 24 : 48),
        child: Column(
          children: [
            ReceiptCard(
              productName: receipt.menuItemName,
              time: receipt.timeUsed,
              isInOverlay: false,
              isTestEnvironment:
                  context.watch<EnvironmentCubit>().state.isTestingEnvironment,
              status: '${Strings.swiped} via ${receipt.productName} ticket',
            ),
          ],
        ),
      ),
    );
  }
}

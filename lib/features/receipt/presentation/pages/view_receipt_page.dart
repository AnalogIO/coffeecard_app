import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/features/environment/domain/entities/environment.dart';
import 'package:coffeecard/features/environment/presentation/cubit/environment_cubit.dart';
import 'package:coffeecard/features/receipt/presentation/widgets/receipt_card.dart';
import 'package:coffeecard/utils/responsive.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewReceiptPage extends StatelessWidget {
  final String name;
  final DateTime time;
  final String paymentStatus;

  const ViewReceiptPage({
    required this.name,
    required this.time,
    required this.paymentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.singleReceiptPageTitle,
      body: BlocBuilder<EnvironmentCubit, EnvironmentState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(deviceIsSmall(context) ? 24 : 48),
            child: Column(
              children: [
                ReceiptCard(
                  productName: name,
                  time: time,
                  isInOverlay: false,
                  isTestEnvironment:
                      state is EnvironmentLoaded && state.env.isTest,
                  status: paymentStatus,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

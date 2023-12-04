import 'package:coffeecard/features/upgrader/presentation/cubit/upgrader_cubit.dart';
import 'package:coffeecard/features/upgrader/presentation/widgets/upgrader_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Upgrader extends StatelessWidget {
  final Widget child;

  const Upgrader({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpgraderCubit, UpgraderState>(
      listener: (context, state) {
        if (state is UpgraderLoaded && state.canUpgrade) {
          ScaffoldMessenger.of(context).showSnackBar(UpgraderSnackbar(context));
        }
      },
      child: child,
    );
  }
}

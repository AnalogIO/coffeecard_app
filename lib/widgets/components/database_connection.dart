import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/environment_type/environment_type_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DatabaseConnectionWidget extends StatelessWidget {
  const DatabaseConnectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EnvironmentTypeCubit(),
      child: BlocConsumer<EnvironmentTypeCubit, EnvironmentTypeState>(
        listenWhen: (previous, current) => !EnvironmentTypeState.widgetAdded,
        listener: (context, state) {
          addTestDBWidget(context);
        },
        builder: (BuildContext context, state) {
          return Container();
        },
      ),
    );
  }

  Future<void> addTestDBWidget(BuildContext context) async {
    //Delay is required to trigger after build
    Future.delayed(Duration.zero, () {
      final entry = OverlayEntry(
        builder: (context) => IgnorePointer(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 100,
              child: Text(
                Strings.testDBString,
                style: TextStyle(color: Colors.red[900], fontSize: 20),
              ),
            ),
          ),
        ),
      );
      final overlay = Overlay.of(context);
      overlay?.insert(entry);
    });
    context.read<EnvironmentTypeCubit>().signalWidgetAdded();
  }
}

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
          context.read<EnvironmentTypeCubit>().addTestDBWidget(context);
        },
        builder: (BuildContext context, state) {
          return Container();
        },
      ),
    );
  }
}

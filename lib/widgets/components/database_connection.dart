import 'package:coffeecard/cubits/database_connection/database_connection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DatabaseConnectionWidget extends StatelessWidget {
  const DatabaseConnectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DatabaseConnectionCubit(),
      child: BlocConsumer<DatabaseConnectionCubit, DatabaseConnectionState>(
        listenWhen: (previous, current) => !DatabaseConnectionState.widgetAdded,
        listener: (context, state) {
          context.read<DatabaseConnectionCubit>().addTestDBWidget(context);
        },
        builder: (BuildContext context, state) {
          return Container();
        },
      ),
    );
  }
}

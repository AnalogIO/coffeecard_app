import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => context.read<AuthenticationCubit>().unauthenticated(),
        child: const Text('Log out'),
      ),
    );
  }
}

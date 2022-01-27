import 'package:coffeecard/blocs/authentication/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => context.read<AuthBloc>().add(Unauthenticated()),
        child: const Text('Log out'),
      ),
    );
  }
}

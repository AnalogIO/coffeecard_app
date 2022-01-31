import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/widgets/pages/home_page.dart';
import 'package:coffeecard/widgets/routers/entry_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthRouter extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;
  const AuthRouter({required this.navigatorKey, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listener: (context, state) {
        navigatorKey.currentState!.pushAndRemoveUntil(
          state.status == AuthStatus.authenticated ? HomePage.route : EntryRouter.route,
          (route) => false,
        );
      },
      child: child,
    );
  }
}

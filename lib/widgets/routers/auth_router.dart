import 'package:coffeecard/blocs/authentication/authentication_bloc.dart';
import 'package:coffeecard/widgets/pages/home_page.dart';
import 'package:coffeecard/widgets/pages/splash_page.dart';
import 'package:coffeecard/widgets/routers/entry_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO Should prevent going back to the splash page.
//      (wrapping pages with WillPopScope is one solution)
class AuthRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      // listenWhen: (previous, current) =>
      //     previous.status != AuthStatus.unknown ||
      //     current.status != AuthStatus.unknown,
      listener: (context, state) {
        Navigator.of(context).pushAndRemoveUntil(
          state.status == AuthStatus.authenticated
              ? HomePage.route
              : EntryRouter.route,
          // TODO Check if route.isFirst is the correct way to handle popUntil.
          //      (Could possibly break with a stack with >2 routes.)
          (route) => route.isFirst,
        );
      },
      child: SplashPage(),
    );
  }
}

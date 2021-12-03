import 'package:coffeecard/blocs/authentication/auth_router_cubit.dart';
import 'package:coffeecard/widgets/pages/home_page.dart';
import 'package:coffeecard/widgets/routers/entry_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthRouterCubit(),
      child: BlocBuilder<AuthRouterCubit, AuthRoute>(
        builder: (context, route) {
          return route == AuthRoute.entry ? EntryRouter() : HomePage();
        },
      ),
    );
  }
}

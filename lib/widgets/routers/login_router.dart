import 'package:coffeecard/blocs/login/login_bloc.dart';
import 'package:coffeecard/persistence/repositories/authentication_service.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/pages/entry/login_email_page.dart';
import 'package:coffeecard/widgets/pages/entry/login_passcode_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO: Write test to ensure that all routes are keys in the routes map
Map<LoginRoute, Widget> routes = {
  LoginRoute.email: LoginEmailPage(),
  LoginRoute.passcode: LoginPasscodePage(),
  LoginRoute.biometric: Container(),
};

class LoginRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return LoginBloc(authService: sl.get<AuthenticationService>());
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.route != current.route,
        // Converted to non-nullable via the ! operator. Might be unsafe if we don't test it properly.
        builder: (context, state) => routes[state.route]!,
      ),
    );
  }
}

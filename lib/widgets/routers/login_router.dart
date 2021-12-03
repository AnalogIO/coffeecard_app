import 'package:coffeecard/blocs/login/login_bloc.dart';
import 'package:coffeecard/persistence/repositories/authentication_service.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/pages/entry/login_email_page.dart';
import 'package:coffeecard/widgets/pages/entry/login_passcode_page.dart';
import 'package:coffeecard/widgets/pages/home_page.dart';
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
      create: (_) => LoginBloc(authService: sl.get<AuthenticationService>()),
      child: BlocConsumer<LoginBloc, LoginState>(
        listenWhen: (_, current) => current.loginSuccess,
        listener: (context, state) {
          // FIXME: E/flutter ( 5318): [ERROR:flutter/lib/ui/ui_dart_state.cc(209)] Unhandled Exception: 'package:flutter/src/widgets/routes.dart': Failed assertion: line 1386 pos 12: 'scope != null': is not true.
          Navigator.of(context).pushAndRemoveUntil(
            HomePage.route,
            (route) => false,
          );
        },
        buildWhen: (previous, current) => previous.route != current.route,
        // Converted to non-nullable via the ! operator. Might be unsafe if we don't test it properly.
        builder: (context, state) => routes[state.route]!,
      ),
    );
  }
}

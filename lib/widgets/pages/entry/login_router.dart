import 'package:coffeecard/blocs/login/login_bloc.dart';
import 'package:coffeecard/widgets/pages/entry/login_email_page.dart';
import 'package:coffeecard/widgets/pages/entry/login_passcode_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.route != current.route,
        builder: (context, state) {
          print(state.route.toString());
          switch (state.route) {
            case LoginRoute.email:
              return LoginEmailPage();
            case LoginRoute.passcode:
              return LoginPasscodePage();
            // case LoginRoute.biometric:
            //   // FIXME add biometric page
            //   return LoginEmailPage();
            default:
              throw Exception('LoginPage: Unknown route');
          }
        },
      ),
    );
  }

  static Route get route =>
      MaterialPageRoute<void>(builder: (_) => LoginRouter());
}

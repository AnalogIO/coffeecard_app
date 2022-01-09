import 'package:coffeecard/blocs/authentication/authentication_bloc.dart';
import 'package:coffeecard/blocs/login/login_bloc.dart';
import 'package:coffeecard/data/repositories/account_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/pages/entry/login/login_email_page.dart';
import 'package:coffeecard/widgets/pages/entry/login/login_passcode_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(
        authBloc: BlocProvider.of<AuthBloc>(context),
        repository: sl.get<AccountRepository>(),
      ),
      child: BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) {
          return previous.emailValidated != current.emailValidated;
        },
        builder: (context, state) {
          if (!state.emailValidated) return LoginEmailPage();
          return LoginPasscodePage();
        },
      ),
    );
  }
}

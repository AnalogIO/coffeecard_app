import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/cubits/login/login_cubit.dart';
import 'package:coffeecard/data/repositories/v1/account_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/pages/login/login_email_page.dart';
import 'package:coffeecard/widgets/pages/login/login_passcode_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
        authenticationCubit: BlocProvider.of<AuthenticationCubit>(context),
        accountRepository: sl.get<AccountRepository>(),
      ),
      child: BlocBuilder<LoginCubit, LoginState>(
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

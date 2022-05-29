import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/cubits/login/login_cubit.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/fast_slide_transition.dart';
import 'package:coffeecard/widgets/components/entry/login/login_numpad.dart';
import 'package:coffeecard/widgets/components/entry/login/login_passcode_dots.dart';
import 'package:coffeecard/widgets/components/loading_overlay.dart';
import 'package:coffeecard/widgets/pages/login/forgot_passcode_page.dart';
import 'package:coffeecard/widgets/pages/login/login_page_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPagePasscode extends StatefulWidget {
  const LoginPagePasscode({required this.email});

  final String email;

  static Route routeWith({required String email}) {
    return FastSlideTransition(child: LoginPagePasscode(email: email));
  }

  @override
  State<LoginPagePasscode> createState() => _LoginPagePasscodeState();
}

class _LoginPagePasscodeState extends State<LoginPagePasscode> {
  void _forgotPasscode(BuildContext context) {
    Navigator.push(
      context,
      ForgotPasscodePage.routeWith(initialValue: widget.email),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
        email: widget.email,
        accountRepository: sl<AccountRepository>(),
        authenticationCubit: sl<AuthenticationCubit>(),
      ),
      child: BlocConsumer<LoginCubit, LoginState>(
        listenWhen: (previous, current) =>
            previous is LoginLoading || current is LoginLoading,
        listener: (context, state) {
          if (state is LoginLoading) {
            LoadingOverlay.of(context).show();
          } else {
            LoadingOverlay.of(context).hide();
          }
        },
        buildWhen: (_, current) => current is! LoginLoading,
        builder: (context, state) {
          final passcode = (state is LoginTypingPasscode) ? state.passcode : '';

          return LoginPageBase(
            resizeToAvoidBottomInset: false,
            title: widget.email,
            inputWidget: LoginPasscodeDots(
              passcodeLength: passcode.length,
              hasError: state is LoginError,
            ),
            defaultHint: Strings.loginPasscodeHint,
            error: state is LoginError ? state.errorMessage : null,
            ctaChildren: const [],
            bottomWidget: Numpad(forgotPasscodeAction: _forgotPasscode),
          );
        },
      ),
    );
  }
}

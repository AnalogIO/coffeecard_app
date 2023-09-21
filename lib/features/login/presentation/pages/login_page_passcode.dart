import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/dialog.dart';
import 'package:coffeecard/core/widgets/components/loading_overlay.dart';
import 'package:coffeecard/core/widgets/components/tickets/rounded_button.dart';
import 'package:coffeecard/core/widgets/fast_slide_transition.dart';
import 'package:coffeecard/features/login/presentation/cubit/login_cubit.dart';
import 'package:coffeecard/features/login/presentation/pages/forgot_passcode_page.dart';
import 'package:coffeecard/features/login/presentation/pages/login_page_base.dart';
import 'package:coffeecard/features/login/presentation/widgets/login_passcode_dots.dart';
import 'package:coffeecard/features/login/presentation/widgets/numpad/numpad.dart';
import 'package:coffeecard/service_locator.dart';
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
    final _ = Navigator.push(
      context,
      ForgotPasscodePage.routeWith(initialValue: widget.email),
    );
  }

  Future<void> resendEmailCallback(LoginCubit cubit) async {
    cubit.resendVerificationEmail(widget.email);
    await appDialog(
      context: context,
      title: Strings.loginVerificationEmailSent,
      children: [
        //TODO: style
        Text(Strings.loginVerificationEmailBody(widget.email)),
      ],
      actions: [
        TextButton(
          //TODO: style
          child: const Text(Strings.buttonOK),
          onPressed: () => closeAppDialog(context),
        ),
      ],
      dismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
        email: widget.email,
        loginUser: sl(),
        resendEmail: sl(),
        authenticationCubit: sl(),
        firebaseAnalyticsEventLogging: sl(),
      ),
      child: BlocConsumer<LoginCubit, LoginState>(
        listenWhen: (previous, current) =>
            previous is LoginLoading || current is LoginLoading,
        listener: (context, state) {
          if (state is LoginLoading) {
            showLoadingOverlay(context);
          } else {
            hideLoadingOverlay(context);
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
            ctaChildren: [
              if (state is LoginEmailNotVerified)
                RoundedButton(
                  text: Strings.loginResendVerificationEmail,
                  onTap: () => resendEmailCallback(context.read<LoginCubit>()),
                ),
            ],
            bottomWidget: Numpad(forgotPasscodeAction: _forgotPasscode),
          );
        },
      ),
    );
  }
}

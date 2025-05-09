import 'package:coffeecard/core/ignore_value.dart';
import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/dialog.dart';
import 'package:coffeecard/core/widgets/components/loading_overlay.dart';
import 'package:coffeecard/core/widgets/components/rounded_button.dart';
import 'package:coffeecard/core/widgets/fast_slide_transition.dart';
import 'package:coffeecard/features/login/presentation/cubit/login_cubit.dart';
import 'package:coffeecard/features/login/presentation/pages/forgot_passcode_page.dart';
import 'package:coffeecard/features/login/presentation/pages/login_page_base.dart';
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
  Future<void> resendMagicLink(LoginCubit cubit) async {
    cubit.resendMagicLink(widget.email);

    // TODO: replace with actual dialogue
    await appDialog(
      context: context,
      title: 'fuck you',
      children: [
        const Text('you piece of shit'),
      ],
      actions: [
        TextButton(
          child: const Text('fucking ok then'),
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
      ),
      child: BlocConsumer<LoginCubit, LoginState>(
        listenWhen: (previous, current) =>
            previous is LoginLoading || current is LoginLoading,
        listener: (context, state) {
          if (state is LoginLoading) {
            ignoreValue(LoadingOverlay.show(context));
          } else {
            LoadingOverlay.hide(context);
          }
        },
        buildWhen: (_, current) => current is! LoginLoading,
        builder: (context, state) {
          return LoginPageBase(
            resizeToAvoidBottomInset: false,
            title: widget.email,
            inputWidget: Container(),
            defaultHint:
                'Vi har sendt en mail til ${widget.email} med et link du kan bruge til at logge ind.',
            error: state is LoginError ? state.errorMessage : null,
            ctaChildren: [
              RoundedButton.bright(
                text: 'Ikke fået den? Send igen',
                onTap: () => resendMagicLink(context.read<LoginCubit>()),
              ),
            ],
          );
        },
      ),
    );
  }
}

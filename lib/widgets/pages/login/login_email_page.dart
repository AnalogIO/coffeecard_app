import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/login/login_cubit.dart';
import 'package:coffeecard/widgets/components/entry/login/login_cta.dart';
import 'package:coffeecard/widgets/components/entry/login/login_email_text_field.dart';
import 'package:coffeecard/widgets/pages/login/login_page.dart';
import 'package:coffeecard/widgets/routers/register_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void _changeRoute(BuildContext context) {
  BlocProvider.of<LoginCubit>(context).clearError();
  Navigator.of(context).push(RegisterFlow.route);
}

class LoginEmailPage extends LoginPage {
  LoginEmailPage()
      : super(
          inputWidget: const LoginEmailTextField(),
          resizeOnKeyboard: true,
          ctaChildren: [
            const LoginCTA(
              text: Strings.loginCreateAccount,
              onPressed: _changeRoute,
            ),
          ],
        );
}

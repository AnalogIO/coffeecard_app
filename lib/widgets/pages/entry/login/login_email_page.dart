import 'package:coffeecard/blocs/login/login_bloc.dart';
import 'package:coffeecard/widgets/components/entry/login/login_cta.dart';
import 'package:coffeecard/widgets/components/entry/login/login_email_text_field.dart';
import 'package:coffeecard/widgets/pages/entry/login/login_page.dart';
import 'package:coffeecard/widgets/pages/entry/register/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void _changeRoute(BuildContext context) {
  BlocProvider.of<LoginBloc>(context).add(const ClearError());
  Navigator.of(context).push(RegisterPage.route);
}

class LoginEmailPage extends LoginPage {
  LoginEmailPage()
      : super(
          inputWidget: const LoginEmailTextField(),
          resizeOnKeyboard: true,
          ctaChildren: [
            const LoginCTA(
              text: "Don't have an account? Make one",
              onPressed: _changeRoute,
            ),
          ],
        );
}

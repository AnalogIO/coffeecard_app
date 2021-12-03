import 'package:coffeecard/widgets/components/entry/login/login_cta.dart';
import 'package:coffeecard/widgets/components/entry/login/login_email_text_field.dart';
import 'package:coffeecard/widgets/pages/entry/login_page.dart';
import 'package:coffeecard/widgets/pages/entry/register_page.dart';
import 'package:flutter/material.dart';

void _changeRoute(BuildContext context) {
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

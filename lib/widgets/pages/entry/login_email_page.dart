import 'package:coffeecard/widgets/components/entry/login/login_cta.dart';
import 'package:coffeecard/widgets/components/entry/login/login_email_text_field.dart';
import 'package:coffeecard/widgets/pages/entry/login_page.dart';
import 'package:flutter/material.dart';

class LoginEmailPage extends LoginPage {
  LoginEmailPage({Key? key})
      : super(
          key: key,
          inputWidget: const LoginEmailTextField(),
          ctaChildren: [
            LoginCTA(
              text: "Don't have an account? Make one",
              onPressed: () {},
            ),
          ],
        );

  static Route get route =>
      MaterialPageRoute<void>(builder: (_) => LoginEmailPage());
}

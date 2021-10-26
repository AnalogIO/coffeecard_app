import 'package:coffeecard/widgets/components/entry/login/login_cta.dart';
import 'package:coffeecard/widgets/components/entry/login/login_numpad.dart';
import 'package:coffeecard/widgets/components/entry/login/login_passcode_dots.dart';
import 'package:coffeecard/widgets/pages/entry/login_page.dart';
import 'package:flutter/material.dart';

class LoginPasscodePage extends LoginPage {
  LoginPasscodePage({Key? key})
      : super(
          key: key,
          inputWidget: LoginPasscodeDots(),
          inputHint: 'Enter passcode',
          ctaChildren: [
            LoginCTA(
              text: 'Sign in using another account',
              onPressed: () {},
            ),
          ],
          bottomWidget: Numpad(),
        );

  static Route get route =>
      MaterialPageRoute<void>(builder: (_) => LoginPasscodePage());
}

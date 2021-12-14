import 'package:coffeecard/blocs/login/login_bloc.dart';
import 'package:coffeecard/widgets/components/entry/login/login_cta.dart';
import 'package:coffeecard/widgets/components/entry/login/login_numpad.dart';
import 'package:coffeecard/widgets/components/entry/login/login_passcode_dots.dart';
import 'package:coffeecard/widgets/pages/entry/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPasscodePage extends LoginPage {
  LoginPasscodePage({Key? key})
      : super(
          key: key,
          inputWidget: LoginPasscodeDots(),
          inputHint: 'Enter passcode',
          resizeOnKeyboard: false,
          ctaChildren: [
            LoginCTA(
              text: 'Sign in using another account',
              onPressed: (context) {
                context.read<LoginBloc>().add(const LoginAsAnotherUser());
              },
            ),
          ],
          bottomWidget: Numpad(),
        );
}

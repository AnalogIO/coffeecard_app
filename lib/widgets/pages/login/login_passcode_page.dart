import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/login/login_cubit.dart';
import 'package:coffeecard/widgets/components/entry/login/login_cta.dart';
import 'package:coffeecard/widgets/components/entry/login/login_numpad.dart';
import 'package:coffeecard/widgets/components/entry/login/login_passcode_dots.dart';
import 'package:coffeecard/widgets/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPasscodePage extends LoginPage {
  LoginPasscodePage({Key? key})
      : super(
          key: key,
          inputWidget: LoginPasscodeDots(),
          inputHint: Strings.loginPasscodeHint,
          resizeOnKeyboard: false,
          ctaChildren: [
            LoginCTA(
              text: Strings.loginSignInOtherAccount,
              onPressed: (context) {
                context.read<LoginCubit>().loginAsAnotherUser();
              },
            ),
          ],
          bottomWidget: Numpad(),
        );
}

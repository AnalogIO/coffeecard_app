import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/login/login_cubit.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/dialog.dart';
import 'package:coffeecard/widgets/components/entry/login/login_cta.dart';
import 'package:coffeecard/widgets/components/entry/login/login_numpad.dart';
import 'package:coffeecard/widgets/components/entry/login/login_passcode_dots.dart';
import 'package:coffeecard/widgets/components/entry/register/email_body.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
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
            const LoginCTA(
              text: Strings.loginForgotYourPasscode,
              onPressed: _pushForgotPasscodePage,
            ),
          ],
          bottomWidget: Numpad(),
        );
}

void _pushForgotPasscodePage(BuildContext context) {
  Navigator.push<void>(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => AppScaffold.withTitle(
        title: Strings.forgotPasscode,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: EmailBody(
            hint: Strings.forgotPasscodeHint,
            onSubmit: (_, email) async {
              //usercubit is not initialized, use the repository directly
              final either =
                  await sl.get<AccountRepository>().requestPasscodeReset(email);

              final String title;
              final String body;
              if (either.isRight) {
                title = Strings.forgotPasscodeLinkSent;
                body = Strings.forgotPasscodeSentRequestTo(email);
              } else {
                title = Strings.forgotPasscodeTitleError;
                body = Strings.forgotPasscodeBodyError;
              }

              appDialog(
                context: context,
                title: title,
                children: [
                  Text(
                    body,
                  )
                ],
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      closeAppDialog(context);
                      closeAppDialog(context);
                    },
                    child: const Text(Strings.buttonOK),
                  ),
                ],
                dismissible: true,
              );
            },
          ),
        ),
      ),
    ),
  );
}

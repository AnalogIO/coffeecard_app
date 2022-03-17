import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/login/login_cubit.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/dialog.dart';
import 'package:coffeecard/widgets/components/entry/login/login_cta.dart';
import 'package:coffeecard/widgets/components/entry/login/login_email_text_field.dart';
import 'package:coffeecard/widgets/components/entry/register/email_body.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/pages/login/login_page.dart';
import 'package:coffeecard/widgets/routers/register_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginEmailPage extends LoginPage {
  LoginEmailPage()
      : super(
          inputWidget: const LoginEmailTextField(),
          resizeOnKeyboard: true,
          ctaChildren: [
            const LoginCTA(
              text: Strings.loginForgotYourPasscode,
              onPressed: _pushForgotPasscodePage,
            ),
            const LoginCTA(
              text: Strings.loginCreateAccount,
              onPressed: _changeRoute,
            ),
          ],
        );
}

void _changeRoute(BuildContext context) {
  BlocProvider.of<LoginCubit>(context).clearError();
  Navigator.of(context).push(RegisterFlow.route);
}

void _pushForgotPasscodePage(BuildContext context) {
  Navigator.push<void>(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => AppScaffold.withTitle(
        title: Strings.changeEmail,
        body: EmailBody(
          onSubmit: (_, email) {
            //usercubit is not initialized, use the repository directly
            sl.get<AccountRepository>().requestPasscodeReset(email);

            appDialog(
              context: context,
              title: Strings.forgotPasscodeLinkSent,
              children: [
                Text(
                  Strings.forgotPasscodeSentRequestTo(email),
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
  );
}

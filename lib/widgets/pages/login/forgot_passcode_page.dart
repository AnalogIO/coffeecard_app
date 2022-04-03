import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/dialog.dart';
import 'package:coffeecard/widgets/components/entry/register/email_body.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';

class ForgotPasscodePage extends StatefulWidget {
  const ForgotPasscodePage({required this.initialValue});

  final String initialValue;

  static Route routeWith({required String initialValue}) {
    return MaterialPageRoute(
      builder: (_) => ForgotPasscodePage(initialValue: initialValue),
    );
  }

  @override
  State<ForgotPasscodePage> createState() => _ForgotPasscodePageState();
}

class _ForgotPasscodePageState extends State<ForgotPasscodePage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.forgotPasscode,
      body: Padding(
        padding: const EdgeInsets.all(16),
        // FIXME generalize email widget body further
        child: EmailBody(
          hint: Strings.forgotPasscodeHint,
          initialValue: widget.initialValue,
          onSubmit: (_, email) async {
            // UserCubit is not initialized, use the repository directly
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

            await appDialog(
              context: context,
              title: title,
              children: [
                Text(
                  body,
                )
              ],
              actions: <Widget>[
                TextButton(
                  onPressed: () => closeAppDialog(context),
                  child: const Text(Strings.buttonOK),
                ),
              ],
              dismissible: true,
            );

            if (mounted && either.isRight) Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

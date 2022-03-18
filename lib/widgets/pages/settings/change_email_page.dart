import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/widgets/components/dialog.dart';
import 'package:coffeecard/widgets/components/entry/register/email_body.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// StatefulWidget is used because we can check if it's still `mounted`
// after an asynchronous gap (showing the app dialog)
class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({required this.currentEmail});
  final String currentEmail;

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.changeEmail,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: EmailBody(
          initialValue: widget.currentEmail,
          hint: 'After changing your email, you must log in again.',
          onSubmit: (context, email) async {
            context.read<UserCubit>().setUserEmail(email);
            await appDialog(
              context: context,
              title: 'Email changed!',
              children: [
                const Text('Please log in again with your updated email.'),
              ],
              actions: [
                TextButton(
                  onPressed: () => closeAppDialog(context),
                  child: const Text(
                    Strings.buttonOK,
                  ),
                ),
              ],
              dismissible: false,
            );
            if (mounted) context.read<AuthenticationCubit>().unauthenticated();
          },
        ),
      ),
    );
  }
}

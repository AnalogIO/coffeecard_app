import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/dialog.dart';
import 'package:coffeecard/core/widgets/components/scaffold.dart';
import 'package:coffeecard/features/authentication/presentation/cubits/authentication_cubit.dart';
import 'package:coffeecard/features/settings/presentation/widgets/forms/change_email_form.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeEmailPage extends StatelessWidget {
  const ChangeEmailPage({required this.currentEmail});
  final String currentEmail;

  static Route routeWith({required String currentEmail}) {
    return MaterialPageRoute(
      builder: (_) => ChangeEmailPage(currentEmail: currentEmail),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.changeEmail,
      applyPadding: true,
      body: ChangeEmailForm(
        currentEmail: currentEmail,
        onSubmit: (email) => _onSubmit(context, email),
      ),
    );
  }

  void _onSubmit(BuildContext context, String email) {
    context.read<UserCubit>().setUserEmail(email);
    appDialog(
      context: context,
      title: Strings.changeEmailSuccess,
      children: [
        const Text(Strings.changeEmailLogInAgainNewEmail),
      ],
      actions: [
        TextButton(
          onPressed: () {
            context.read<AuthenticationCubit>().unauthenticated();
            closeAppDialog(context);
          },
          child: const Text(
            Strings.buttonOK,
          ),
        ),
      ],
      dismissible: false,
    );
  }
}

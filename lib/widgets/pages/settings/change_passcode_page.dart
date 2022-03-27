import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/widgets/components/entry/register/passcode_body.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasscodePage extends StatelessWidget {
  const ChangePasscodePage();

  static Route get route =>
      MaterialPageRoute(builder: (_) => const ChangePasscodePage());

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.changePasscode,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: PasscodeBody(
          // TODO: Hint should be changed here
          // hint: Strings.changePasscodeHint,
          onSubmit: (context, passcode) async {
            context.read<UserCubit>().setUserPasscode(passcode);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

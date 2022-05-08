import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/register/register_cubit.dart';
import 'package:coffeecard/utils/fast_slide_transition.dart';
import 'package:coffeecard/widgets/components/email_button_group.dart';
import 'package:coffeecard/widgets/pages/register/register_page_base.dart';
import 'package:coffeecard/widgets/pages/register/register_page_passcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPageEmail extends StatelessWidget {
  const RegisterPageEmail();

  static Route get route =>
      FastSlideTransition(child: const RegisterPageEmail());

  @override
  Widget build(BuildContext context) {
    return RegisterPageBase(
      sectionTitle: Strings.registerEmailTitle,
      body: EmailButtonGroup(
        hint: Strings.registerEmailHint,
        onSubmit: (context, email) {
          context.read<RegisterCubit>().setEmail(email);
          Navigator.push(context, RegisterPagePasscode.route);
        },
      ),
    );
  }
}

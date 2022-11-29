import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/register/register_cubit.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/fast_slide_transition.dart';
import 'package:coffeecard/widgets/components/dialog.dart';
import 'package:coffeecard/widgets/components/forms/register/register_name_form.dart';
import 'package:coffeecard/widgets/components/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class RegisterPageName extends StatelessWidget {
  const RegisterPageName({required this.email, required this.passcode});

  final String email;
  final String passcode;

  static Route routeWith({required String email, required String passcode}) {
    return FastSlideTransition(
      child: RegisterPageName(email: email, passcode: passcode),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(repository: sl<AccountRepository>()),
      child: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) return _showSuccessDialog(context);
          if (state is RegisterError) return _showErrorDialog(context, state);
        },
        child: RegisterNameForm(
          email: email,
          passcode: passcode,
          programmeId: 0,
        ), //FIXME: programme
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    appDialog(
      context: context,
      dismissible: false,
      transparentBarrier: true,
      title: Strings.registerSuccessHeading,
      children: [
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: Strings.registerSuccessBody),
              TextSpan(
                text: email,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
      ],
      actions: [
        TextButton(
          onPressed: () {
            closeAppDialog(context);
            hideLoadingOverlay(context);
            // Exits the register flow
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text(Strings.buttonOK),
        )
      ],
    );
  }

  void _showErrorDialog(BuildContext context, RegisterError state) {
    appDialog(
      context: context,
      dismissible: false,
      transparentBarrier: true,
      title: Strings.registerFailureHeading,
      children: [
        const Text(Strings.registerFailureBody),
        const Gap(12),
        Text(state.errorMessage),
      ],
      actions: [
        TextButton(
          onPressed: () {
            closeAppDialog(context);
            hideLoadingOverlay(context);
          },
          child: const Text(Strings.buttonClose),
        )
      ],
    );
  }
}

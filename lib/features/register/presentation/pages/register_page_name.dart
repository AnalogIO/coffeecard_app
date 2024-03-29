import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/dialog.dart';
import 'package:coffeecard/core/widgets/components/loading_overlay.dart';
import 'package:coffeecard/core/widgets/fast_slide_transition.dart';
import 'package:coffeecard/features/register/presentation/cubit/register_cubit.dart';
import 'package:coffeecard/features/register/presentation/widgets/forms/register_name_form.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class RegisterPageName extends StatelessWidget {
  const RegisterPageName({
    required this.email,
    required this.passcode,
    required this.occupationId,
  });

  final String email;
  final String passcode;
  final int occupationId;

  static Route routeWith({
    required String email,
    required String passcode,
    required int occupationId,
  }) {
    return FastSlideTransition(
      child: RegisterPageName(
        email: email,
        passcode: passcode,
        occupationId: occupationId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocProvider(
        create: (_) => sl<RegisterCubit>(),
        child: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) return _showSuccessDialog(context);
            if (state is RegisterError) return _showErrorDialog(context, state);
          },
          child: RegisterNameForm(
            email: email,
            passcode: passcode,
            occupationId: occupationId,
          ),
        ),
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
            LoadingOverlay.hide(context);
            // Exits the register flow
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text(Strings.buttonOK),
        ),
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
        Text(state.message),
      ],
      actions: [
        TextButton(
          onPressed: () {
            closeAppDialog(context);
            LoadingOverlay.hide(context);
          },
          child: const Text(Strings.buttonClose),
        ),
      ],
    );
  }
}

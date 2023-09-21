import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/dialog.dart';
import 'package:coffeecard/core/widgets/components/helpers/unordered_list_builder.dart';
import 'package:coffeecard/core/widgets/components/loading_overlay.dart';
import 'package:coffeecard/features/form/presentation/widgets/form.dart';
import 'package:coffeecard/features/register/presentation/cubit/register_cubit.dart';
import 'package:coffeecard/utils/input_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class RegisterNameForm extends StatefulWidget {
  const RegisterNameForm({
    required this.email,
    required this.passcode,
    required this.occupationId,
  });
  final String email;
  final String passcode;
  final int occupationId;

  @override
  State<RegisterNameForm> createState() => _RegisterNameFormState();
}

class _RegisterNameFormState extends State<RegisterNameForm> {
  @override
  Widget build(BuildContext context) {
    return FormBase(
      inputValidators: [
        InputValidators.nonEmptyString(
          errorMessage: Strings.registerNameEmpty,
        ),
      ],
      title: Strings.registerNameTitle,
      label: Strings.registerNameLabel,
      maxLength: 30,
      onSubmit: (text) => _showTerms(context, text),
    );
  }

  Future<void> _showTerms(BuildContext context, String name) async {
    showLoadingOverlay(context);
    // Allow keyboard to disappear before showing dialog
    final _ = await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;

    // Shows the terms to the user before proceeding with the registration.
    await appDialog(
      context: context,
      title: Strings.registerTermsHeading,
      transparentBarrier: true,
      dismissible: false,
      children: [
        const Text(Strings.registerTermsIntroduction),
        const Gap(16),
        UnorderedListBuilder(
          texts: Strings.registerTerms,
          builder: (s) => Text(s),
        ),
      ],
      actions: [
        TextButton(
          child: const Text(Strings.buttonDecline),
          onPressed: () {
            closeAppDialog(context);
            if (mounted) hideLoadingOverlay(context);
          },
        ),
        TextButton(
          child: const Text(Strings.buttonAccept),
          onPressed: () {
            context.read<RegisterCubit>().register(
                  name,
                  widget.email,
                  widget.passcode,
                  widget.occupationId,
                );
            closeAppDialog(context);
          },
        ),
      ],
    );
  }
}

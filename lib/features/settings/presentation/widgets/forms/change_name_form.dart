import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/features/shared/form.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeNameForm extends StatelessWidget {
  const ChangeNameForm({required this.currentName});

  final String currentName;

  @override
  Widget build(BuildContext context) {
    return FormBase(
      inputValidators: [
        InputValidators.nonEmptyString(
          errorMessage: Strings.registerNameEmpty,
        ),
      ],
      label: Strings.registerNameLabel,
      initialValue: currentName,
      maxLength: 30,
      onSubmit: (name) => _onSubmit(context, name),
    );
  }

  void _onSubmit(BuildContext context, String name) {
    if (currentName != name) {
      context.read<UserCubit>().setUserName(name);
    }
    Navigator.pop(context);
  }
}

import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/cubits/login/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginEmailTextField extends StatelessWidget {
  const LoginEmailTextField();

  @override
  Widget build(BuildContext context) {
    void onSubmit() {
      context.read<LoginCubit>().validateEmail();
    }

    void onChange(String email) {
      context.read<LoginCubit>().updateEmail(email);
    }

    InputDecoration inputDecoration({required bool hasError}) {
      final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: hasError
            ? const BorderSide(color: AppColor.error, width: 2)
            : const BorderSide(color: Colors.transparent, width: 0),
      );

      return InputDecoration(
        constraints: const BoxConstraints(maxWidth: 260),
        hintStyle: const TextStyle(color: AppColor.gray),
        hintText: Strings.loginHintEmail,
        border: const OutlineInputBorder(),
        enabledBorder: border,
        focusedBorder: border,
        filled: true,
        fillColor: AppColor.white,
        suffixIcon: IconButton(
          splashColor: Colors.transparent,
          icon: const Icon(Icons.arrow_forward, size: 20),
          onPressed: onSubmit,
          tooltip: Strings.loginTooltipContinue,
        ),
        contentPadding: const EdgeInsets.only(
          top: 12,
          bottom: 12,
          left: 24,
        ),
      );
    }

    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return TextField(
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          decoration: inputDecoration(hasError: state.hasError),
          style: const TextStyle(color: AppColor.primary),
          cursorWidth: 1,
          onEditingComplete: onSubmit,
          onChanged: onChange,
        );
      },
    );
  }
}

import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/blocs/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// TODO Error could be an enum, e.g. LoginError.None or LoginError.InvalidEmail

// FIXME Don't hide the keyboard when submitting via the keyboard action button
// (Most likely requires a TextFormField)
class LoginEmailTextField extends StatelessWidget {
  const LoginEmailTextField();

  @override
  Widget build(BuildContext context) {
    void onSubmit() {
      context.read<LoginBloc>().add(const LoginEmailSubmit());
    }

    void onChange(String email) {
      context.read<LoginBloc>().add(LoginEmailChange(email));
    }

    InputDecoration inputDecoration(LoginState state) {
      final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: state.hasError
            ? const BorderSide(color: AppColor.error, width: 2)
            : const BorderSide(color: Colors.transparent, width: 0),
      );

      return InputDecoration(
        constraints: const BoxConstraints(maxWidth: 260),
        hintStyle: const TextStyle(color: AppColor.gray),
        hintText: 'Email...',
        border: const OutlineInputBorder(),
        enabledBorder: border,
        focusedBorder: border,
        filled: true,
        fillColor: AppColor.white,
        suffixIcon: IconButton(
          splashColor: Colors.transparent,
          icon: const Icon(Icons.arrow_forward, size: 20),
          onPressed: onSubmit,
          tooltip: 'Continue',
        ),
        contentPadding: const EdgeInsets.only(
          top: 12,
          bottom: 12,
          left: 24,
        ),
      );
    }

    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextField(
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          decoration: inputDecoration(state),
          style: const TextStyle(color: AppColor.primary),
          cursorWidth: 1,
          onSubmitted: (_) => onSubmit(),
          onChanged: onChange,
        );
      },
    );
  }
}

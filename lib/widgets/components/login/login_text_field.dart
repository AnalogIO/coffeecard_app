import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/blocs/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginTextField extends StatelessWidget {

  const LoginTextField();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.onPage != current.onPage || current is LoginStateError || previous is LoginStateError  ,
        builder: (context, state) {
          final _border = OutlineInputBorder(
              borderSide: state is LoginStateError
                  ? const BorderSide(color: AppColor.error, width: 2)
                  : BorderSide.none,
              borderRadius: BorderRadius.circular(32));

          void submit() {
            context.read<LoginBloc>().add(const LoginEmailSubmitted());
          }

          final inputDecoration = InputDecoration(
            hintText: (state is LoginStateError)
                ? state.error
                : ((state.onPage == OnPage.inputPassword) ? "Enter passcode" : ""),
            hintStyle: const TextStyle(color: AppColor.gray),
            border: const OutlineInputBorder(),
            enabledBorder: _border,
            focusedBorder: _border,
            filled: true,
            fillColor: AppColor.white,
            suffixIcon: IconButton(
              splashColor: Colors.transparent,
              icon: Icon(Icons.arrow_forward),
              onPressed: () => submit(),
              tooltip: 'Go',
            ),
            contentPadding:
                const EdgeInsets.only(top: 13, bottom: 13, left: 24, right: 64),
          );

          return TextField(
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            decoration: inputDecoration,
            style: const TextStyle(color: AppColor.primary),
            cursorWidth: 1,
            onSubmitted: (_) => submit(),
            onChanged: (email) {
              context.read<LoginBloc>().add(LoginEmailChanged(email));
            },
          );
        });
  }
}

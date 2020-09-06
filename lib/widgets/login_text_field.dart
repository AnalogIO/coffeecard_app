import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/blocs/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginTextField extends StatelessWidget {

  const LoginTextField();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {},
        buildWhen: (previous, current) => previous.onPage != current.onPage || previous.error != current.error,
        builder: (context, state) {
          final _border = OutlineInputBorder(
              borderSide: state.error.isNotEmpty
                  ? BorderSide(color: AppColor.error, width: 2)
                  : BorderSide.none,
              borderRadius: BorderRadius.circular(32));

          void submit() {
            context.bloc<LoginBloc>().add(const LoginEmailSubmitted()) ;
          }

          final inputDecoration = InputDecoration(
            hintText: (state.error.isEmpty)
                ? ((state.onPage == OnPage.inputPassword) ? "Enter passcode" : "")
                : state.error,
            hintStyle: TextStyle(color: AppColor.gray),
            border: OutlineInputBorder(),
            enabledBorder: _border,
            focusedBorder: _border,
            filled: true,
            fillColor: AppColor.white,
            suffixIcon: IconButton(
              enableFeedback: true,
              splashColor: Colors.transparent,
              icon: Icon(Icons.arrow_forward),
              onPressed: () => submit(),
              tooltip: 'Go',
            ),
            contentPadding:
                EdgeInsets.only(top: 13, bottom: 13, left: 24, right: 64),
          );

          return TextField(
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            decoration: inputDecoration,
            style: TextStyle(color: AppColor.primary),
            cursorWidth: 1,
            onSubmitted: (_) => submit(),
            onChanged: (email) {context.bloc<LoginBloc>().add(LoginEmailChanged(email) ); },
          );
        });
  }
}

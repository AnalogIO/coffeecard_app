import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../base/style/colors.dart';
import '../../../blocs/login/login_bloc.dart';

class LoginInputHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
        },
        buildWhen: (previous, current) => previous.error != current.error || previous.onPage != current.onPage,
        builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(top: 16, bottom: 12),
          child: Text(
            (state.error.isEmpty)
              ? ((state.onPage == OnPage.inputPassword) ? "Enter passcode" : "")
              : state.error,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: (state.error.isEmpty)
                ? AppColor.white
                : AppColor.highlight,
              fontSize: 14
            ),
          ),
        );
      }
    );
  }
}

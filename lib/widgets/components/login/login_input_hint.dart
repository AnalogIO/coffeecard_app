import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/style/colors.dart';
import '../../../blocs/login/login_bloc.dart';

class LoginInputHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {},
        buildWhen: (previous, current) => current is LoginStateError || previous is LoginStateError || previous.onPage != current.onPage,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 12),
            child: Text(
              // TODO Use specialized subclasses of LoginState to handle e.g. errors
              // TODO Store strings in Global file (reuse and potentially localization)
              (state is LoginStateError) ? state.error  : ((state.onPage == OnPage.inputPassword)
                                                        ? "Enter passcode"
                                                        : ""),
              textAlign: TextAlign.center,
              style: TextStyle(color: (state is LoginStateError) ? AppColor.highlight : AppColor.white, fontSize: 14),
            ),
          );
        });
  }
}

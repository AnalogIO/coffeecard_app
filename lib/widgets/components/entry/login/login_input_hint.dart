import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/cubits/login/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginInputHint extends StatelessWidget {
  final String defaultHint;

  const LoginInputHint({
    Key? key,
    required this.defaultHint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return Text(
          state.error ?? defaultHint,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: state.hasError ? AppColor.error : AppColor.white,
            fontSize: 14,
          ),
        );
      },
    );
  }
}

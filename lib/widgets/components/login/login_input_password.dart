import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../base/style/colors.dart';
import '../../../blocs/login/login_bloc.dart';

class LoginInputPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
        },
        builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (i) {
            return PasswordCircle(
              index: i,
              passwordLength: state.password.length,
              isError: state is LoginStateError
            );
          })
        );
      }
    );
  }
}

class PasswordCircle extends StatelessWidget {
  final int index;
  final int passwordLength;
  final bool isError;
  const PasswordCircle({
    this.index,
    this.passwordLength,
    this.isError
  });

  @override
  Widget build(BuildContext context) {
    final bool current = index == passwordLength;
    final bool previous = index < passwordLength;

    Color fill = AppColor.white.withAlpha(70);

    //double opacity = 1; // TODO Use
    const double borderWidth = 0;
    final Color borderColor = Colors.transparent;

    if (current) {
      //opacity = 0; // TODO Use
      // borderColor = AppColors.creamLighter;
      // borderWidth = 4;
    }
    if (previous) {
      fill = AppColor.white;
      // borderColor = AppColors.coffee;
      // borderWidth = 12;
    }
    if (isError) {
      fill = AppColor.highlight;
      // borderColor = AppColors.orange;
      // borderWidth = 4;
    }

    return Container(
      width: 20,
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: fill,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth
        )
      )
    );
  }
}

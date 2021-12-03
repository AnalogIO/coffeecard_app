import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/blocs/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPasscodeDots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            4,
            (index) => _PasscodeDot(
              isLit: index < state.passcode.length,
              isError: state.hasError,
            ),
            growable: false,
          ),
        );
      },
    );
  }
}

class _PasscodeDot extends StatelessWidget {
  final bool isLit;
  final bool isError;
  const _PasscodeDot({
    required this.isLit,
    required this.isError,
  });

  @override
  Widget build(BuildContext context) {
    final Color fill = isError ? AppColor.error : AppColor.white;
    final double opacity = isLit || isError ? 1 : 0.35;

    return Container(
      width: 20,
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 15),
      decoration: BoxDecoration(
        color: fill.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

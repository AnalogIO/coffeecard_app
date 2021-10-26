import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/blocs/login/login_bloc.dart';
import 'package:coffeecard/widgets/analog_logo.dart';
import 'package:coffeecard/widgets/components/entry/login/login_input_hint.dart';
import 'package:coffeecard/widgets/components/entry/login/login_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LoginPage extends StatelessWidget {
  final Widget inputWidget;
  final String inputHint;
  final List<Widget> ctaChildren;
  final Widget bottomWidget;

  const LoginPage({
    Key? key,
    required this.inputWidget,
    required this.ctaChildren,
    this.inputHint = '',
    this.bottomWidget = const SizedBox.shrink(), // Empty widget
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.hasError || current.hasError,
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.primary,
          body: Column(
            children: [
              Expanded(
                child: SafeArea(
                  minimum: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Expanded(child: Container()),
                      const AnalogLogo(),
                      Container(height: 16),
                      const LoginTitle(),
                      Container(height: 16),
                      inputWidget,
                      Container(height: 16),
                      LoginInputHint(defaultHint: inputHint),
                      Container(height: 12),
                      ...ctaChildren,
                      // Expanded(child: Container()),
                    ],
                  ),
                ),
              ),
              bottomWidget,
            ],
          ),
        );
      },
    );
  }
}

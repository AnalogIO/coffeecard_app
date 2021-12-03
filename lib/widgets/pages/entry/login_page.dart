import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/blocs/login/login_bloc.dart';
import 'package:coffeecard/widgets/analog_logo.dart';
import 'package:coffeecard/widgets/components/entry/login/login_input_hint.dart';
import 'package:coffeecard/widgets/components/entry/login/login_title.dart';
import 'package:coffeecard/widgets/components/loading_overlay.dart';
import 'package:coffeecard/widgets/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class LoginPage extends StatelessWidget {
  final Widget inputWidget;
  final List<Widget> ctaChildren;
  final bool resizeOnKeyboard;
  final String inputHint;
  final Widget bottomWidget;

  const LoginPage({
    Key? key,
    required this.inputWidget,
    required this.ctaChildren,
    required this.resizeOnKeyboard,
    this.inputHint = '',
    this.bottomWidget = const SizedBox.shrink(), // Empty widget
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final overlay = LoadingOverlay.of(context);

    return BlocConsumer<LoginBloc, LoginState>(
      listenWhen: (previous, current) {
        return previous.loading || current.loading || current.loginSuccess;
      },
      listener: (context, state) {
        if (state.loginSuccess) {
          // FIXME: E/flutter ( 5318): [ERROR:flutter/lib/ui/ui_dart_state.cc(209)] Unhandled Exception: 'package:flutter/src/widgets/routes.dart': Failed assertion: line 1386 pos 12: 'scope != null': is not true.
          Navigator.of(context).pushAndRemoveUntil(
            HomePage.route,
            (route) => false,
          );
        }
        state.loading ? overlay.show() : overlay.hide();
      },
      buildWhen: (previous, current) => previous.hasError || current.hasError,
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: resizeOnKeyboard,
          backgroundColor: AppColor.primary,
          body: Column(
            children: [
              Expanded(
                child: SafeArea(
                  minimum: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AnalogLogo(),
                      Container(height: 16),
                      const LoginTitle(),
                      Container(height: 16),
                      inputWidget,
                      Container(height: 16),
                      LoginInputHint(defaultHint: inputHint),
                      Container(height: 12),
                      ...ctaChildren,
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

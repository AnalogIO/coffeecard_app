import 'package:coffeecard/cubits/login/login_cubit.dart';
import 'package:coffeecard/utils/responsive.dart';
import 'package:coffeecard/widgets/analog_logo.dart';
import 'package:coffeecard/widgets/components/entry/login/login_input_hint.dart';
import 'package:coffeecard/widgets/components/entry/login/login_title.dart';
import 'package:coffeecard/widgets/components/loading_overlay.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

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

    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (previous, current) => previous.loading || current.loading,
      listener: (context, state) {
        state.loading ? overlay.show() : overlay.hide();
      },
      buildWhen: (previous, current) => previous.hasError || current.hasError,
      builder: (context, state) {
        return AppScaffold.withoutTitle(
          resizeToAvoidBottomInset: resizeOnKeyboard,
          body: Column(
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Gap(deviceIsSmall(context) ? 16 : 64),
                      const AnalogLogo(),
                      const Gap(16),
                      const LoginTitle(),
                      const Gap(16),
                      inputWidget,
                      const Gap(16),
                      LoginInputHint(defaultHint: inputHint),
                      const Gap(12),
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

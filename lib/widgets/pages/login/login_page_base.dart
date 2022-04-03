import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/utils/responsive.dart';
import 'package:coffeecard/widgets/analog_logo.dart';
import 'package:coffeecard/widgets/components/entry/login/login_input_hint.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LoginPageBase extends StatelessWidget {
  const LoginPageBase({
    required this.resizeToAvoidBottomInset,
    required this.title,
    required this.inputWidget,
    this.defaultHint = '',
    this.error,
    required this.ctaChildren,
    this.bottomWidget,
  });

  final bool resizeToAvoidBottomInset;
  final String title;
  final Widget inputWidget;
  final String defaultHint;
  final String? error;
  final List<Widget> ctaChildren;
  final Widget? bottomWidget;

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withoutTitle(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Gap(deviceIsSmall(context) ? 12 : 64),
                const AnalogLogo(),
                const Gap(16),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  // FIXME: Should be defined in AppTextStyle
                  style: const TextStyle(
                    color: AppColor.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Gap(16),
                inputWidget,
                const Gap(16),
                LoginInputHint(defaultHint: defaultHint, error: error),
                const Gap(12),
                ...ctaChildren,
                const Gap(12),
              ],
            ),
          ),
          if (bottomWidget != null) bottomWidget!,
        ],
      ),
    );
  }
}

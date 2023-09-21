import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/helpers/responsive.dart';
import 'package:coffeecard/core/widgets/components/scaffold.dart';
import 'package:coffeecard/core/widgets/images/analog_logo.dart';
import 'package:coffeecard/core/widgets/upgrade_alert.dart';
import 'package:coffeecard/features/login/presentation/widgets/login_input_hint.dart';
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
    return UpgradeAlert(
      child: AppScaffold.withoutTitle(
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
                    style: AppTextStyle.pageTitle,
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
      ),
    );
  }
}

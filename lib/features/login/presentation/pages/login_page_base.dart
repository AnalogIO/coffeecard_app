import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/scaffold.dart';
import 'package:coffeecard/core/widgets/design/glass_surface.dart';
import 'package:coffeecard/core/widgets/images/analog_logo.dart';
import 'package:coffeecard/features/login/presentation/widgets/login_input_hint.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:upgrader/upgrader.dart';

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
        body: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  return SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: EdgeInsets.fromLTRB(28, 24, 28,
                        MediaQuery.viewInsetsOf(context).bottom + 24),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight - 48),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 440),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Center(child: AnalogLogo()),
                              const Gap(16),
                              if (bottomWidget == null) ...[
                                Text(
                                  Strings.loginTagline,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.pageTitle.copyWith(
                                    fontSize: 26,
                                    height: 1.2,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const Gap(24),
                              ],
                              GlassSurface(
                                dark: true,
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(title,
                                        textAlign: TextAlign.left,
                                        style: AppTextStyle.pageTitle.copyWith(
                                            fontSize: 24, letterSpacing: -.5)),
                                    const Gap(20),
                                    inputWidget,
                                    if (error != null ||
                                        defaultHint.isNotEmpty) ...[
                                      const Gap(16),
                                      LoginInputHint(
                                          defaultHint: defaultHint,
                                          error: error),
                                    ],
                                    const Gap(12),
                                    ...ctaChildren,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              if (bottomWidget != null) bottomWidget!,
            ],
          ),
        ),
      ),
    );
  }
}

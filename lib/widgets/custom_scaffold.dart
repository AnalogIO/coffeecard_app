import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/environment/environment_cubit.dart';
import 'package:coffeecard/widgets/components/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

enum _AppScaffoldType { normal, login }

extension _AppScaffoldTypeIs on _AppScaffoldType {
  bool get isNormal => this == _AppScaffoldType.normal;
  bool get isLogin => !isNormal;
}

class AppScaffold extends StatelessWidget {
  AppScaffold({
    required String title,
    required this.body,
  })  : type = _AppScaffoldType.normal,
        title = Text(title, style: AppTextStyle.pageTitle);

  const AppScaffold.login({
    required this.body,
  })  : type = _AppScaffoldType.login,
        title = null;

  final _AppScaffoldType type;
  final Widget? title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background color is set to avoid a thin line
      // between the AppBar and the _EnvironmentBanner.
      // The actual background of the body is defined
      // in the child of the Expanded widget below.
      backgroundColor: AppColor.primary,
      // If type.isLogin, then the AppBar is an empty 24dp tall padding.
      // Otherwise, display a normal AppBar with a title widget.
      appBar: AppBar(
        title: title,
        elevation: 0,
        toolbarHeight: type.isLogin ? 24 : null,
      ),
      body: BlocBuilder<EnvironmentCubit, Environment>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.isTest) const _EnvironmentBanner(tappable: true),
              Expanded(
                child: Container(
                  color: type.isNormal ? AppColor.background : null,
                  child: body,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// TODO: Extract to its own file as more widgets want to use this widget
class _EnvironmentBanner extends StatelessWidget {
  const _EnvironmentBanner({required this.tappable});
  final bool tappable;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.primary,
      padding: const EdgeInsets.only(bottom: 8),
      child: Center(
        child: _EnvironmentButton(tappable: tappable),
      ),
    );
  }
}

class _EnvironmentButton extends StatelessWidget {
  const _EnvironmentButton({required this.tappable});
  final bool tappable;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: tappable
          ? () => appDialog(
                context: context,
                title: 'Connected to test environment',
                children: [
                  Text(
                    'The functionality of this app is for testing purposes only.',
                    style: AppTextStyle.settingKey,
                  ),
                  const Gap(8),
                  Text(
                    'User account information is not shared with the production environment. This means you will need a separate account for this environment.',
                    style: AppTextStyle.settingKey,
                  ),
                  const Gap(8),
                  Text(
                    'Tickets you buy or swipe are *NOT VALID* for use at Cafe Analog.',
                    style: AppTextStyle.settingKey,
                  ),
                ],
                actions: [
                  TextButton(
                    child: const Text('Understood'),
                    onPressed: () => closeAppDialog(context),
                  ),
                ],
                dismissible: true,
              )
          : null,
      style: TextButton.styleFrom(
        backgroundColor: AppColor.white,
        padding: const EdgeInsets.only(left: 16, right: 12),
        shape: const StadiumBorder(),
        visualDensity: VisualDensity.comfortable,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Connected to test environment',
            style: AppTextStyle.environmentNotifier,
          ),
          if (tappable) const Gap(8),
          if (tappable)
            const Icon(
              Icons.info_outline,
              color: AppColor.primary,
              size: 18,
            ),
        ],
      ),
    );
  }
}

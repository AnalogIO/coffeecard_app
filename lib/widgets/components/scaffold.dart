import 'package:coffeecard/base/strings_environment.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/environment/environment_cubit.dart';
import 'package:coffeecard/widgets/components/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class AppScaffold extends StatelessWidget {
  final Widget? title;
  final Widget body;
  final bool resizeToAvoidBottomInset;

  AppScaffold({
    required String title,
    this.resizeToAvoidBottomInset = true,
    required this.body,
  }) : title = Text(title, style: AppTextStyle.pageTitle);

  const AppScaffold.noTitle({
    this.resizeToAvoidBottomInset = true,
    required this.body,
  }) : title = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      // The background color is set to avoid a thin line
      // between the AppBar and the _EnvironmentBanner.
      // The actual background of the body is defined
      // in the child of the Expanded widget below.
      backgroundColor: AppColor.primary,
      // If a title is not provided, then the AppBar is an empty 24dp tall padding.
      // Otherwise, display a normal AppBar with a title widget.
      appBar: AppBar(
        title: title,
        elevation: 0,
        toolbarHeight: (title == null) ? 24 : null,
      ),
      body: BlocBuilder<EnvironmentCubit, Environment>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (state.isTest) const _EnvironmentBanner(tappable: true),
              Expanded(
                child: Container(
                  color: (title != null) ? AppColor.background : null,
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
      padding: const EdgeInsets.only(bottom: 2),
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
                title: TestEnvironmentStrings.title,
                children: [
                  Text(
                    TestEnvironmentStrings.description[0],
                    style: AppTextStyle.settingKey,
                  ),
                  const Gap(8),
                  Text(
                    TestEnvironmentStrings.description[1],
                    style: AppTextStyle.settingKey,
                  ),
                  const Gap(8),
                  Text(
                    TestEnvironmentStrings.description[2],
                    style: AppTextStyle.settingKey,
                  ),
                ],
                actions: [
                  TextButton(
                    child: const Text(TestEnvironmentStrings.understood),
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
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            TestEnvironmentStrings.title,
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

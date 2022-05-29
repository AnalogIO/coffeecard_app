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
  final Color backgroundColor;
  final bool resizeToAvoidBottomInset;
  final double? appBarHeight;

  bool get hasTitle => title != null;

  /// A Scaffold with a normal app bar.
  ///
  /// If connected to test envrionment, an environment
  /// warning button is shown below the title.
  ///
  /// The body's background color is always `AppColor.background`.
  AppScaffold.withTitle({
    required String title,
    this.resizeToAvoidBottomInset = true,
    required this.body,
  })  : title = Text(title, style: AppTextStyle.pageTitle),
        backgroundColor = AppColor.background,
        // Use default app bar height
        appBarHeight = null;

  /// A Scaffold with an empty, 48 dp tall app bar.
  ///
  /// If connected to test envrionment, an environment warning
  /// button is shown where the title would normally show.
  ///
  /// The body's background color is, by default, the same as the app bar.
  const AppScaffold.withoutTitle({
    this.backgroundColor = AppColor.primary,
    this.resizeToAvoidBottomInset = true,
    required this.body,
  })  : title = null,
        appBarHeight = 48;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      // The background color is set to avoid a thin line
      // between the AppBar and the _EnvironmentBanner.
      // The actual background of the body is defined
      // in the child of the Expanded widget below.
      backgroundColor: AppColor.primary,
      appBar: AppBar(
        title: hasTitle ? title : const _EnvironmentButton(),
        centerTitle: hasTitle ? null : true,
        toolbarHeight: appBarHeight,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasTitle) const _EnvironmentBanner(),
          Expanded(
            child: Container(
              color: backgroundColor,
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}

// TODO: Extract to its own file as more widgets want to use this widget
class _EnvironmentBanner extends StatelessWidget {
  const _EnvironmentBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.primary,
      child: const Center(child: _EnvironmentButton()),
    );
  }
}

class _EnvironmentButton extends StatelessWidget {
  const _EnvironmentButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnvironmentCubit, EnvironmentState>(
      builder: (context, state) {
        final bool isTestEnvironment =
            state is EnvironmentLoaded && state.isTestEnvironment;

        if (!isTestEnvironment) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: TextButton(
            onPressed: () => appDialog(
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
            ),
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
                const Gap(8),
                const Icon(
                  Icons.info_outline,
                  color: AppColor.primary,
                  size: 18,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

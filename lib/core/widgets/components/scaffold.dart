import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/features/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppScaffold extends StatelessWidget {
  /// A Scaffold with a normal app bar.
  ///
  /// If connected to test environment, a [TestingEnvironmentBanner]
  /// is shown below the title.
  ///
  /// The body's background color is always `AppColor.background`.
  AppScaffold.withTitle({
    required String title,
    this.applyPadding = false,
    this.resizeToAvoidBottomInset = true,
    required this.body,
  })  : title = Text(title, style: AppTextStyle.pageTitle),
        backgroundColor = AppColors.background,
        // Use default app bar height
        appBarHeight = null;

  /// A Scaffold with an empty, 48 dp tall app bar.
  ///
  /// If connected to test environment, an [TestingEnvironmentButton]
  /// is shown where the title would normally show.
  ///
  /// The body's background color is, by default, the same as the app bar.
  const AppScaffold.withoutTitle({
    this.backgroundColor = AppColors.primary,
    this.resizeToAvoidBottomInset = true,
    required this.body,
  })  : title = null,
        applyPadding = false,
        appBarHeight = 48;

  final Widget? title;
  final Widget body;
  final bool applyPadding;
  final Color backgroundColor;
  final bool resizeToAvoidBottomInset;
  final double? appBarHeight;

  bool get hasTitle => title != null;

  @override
  Widget build(BuildContext context) {
    final isTestEnvironment =
        context.watch<EnvironmentCubit>().state.isTestingEnvironment;

    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      // The background color is set to avoid a thin line
      // between the AppBar and the _EnvironmentBanner.
      // The actual background of the body is defined
      // in the child of the Expanded widget below.
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: (!hasTitle && isTestEnvironment)
            ? const TestingEnvironmentButton()
            : title,
        centerTitle: !hasTitle,
        toolbarHeight: appBarHeight,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (hasTitle && isTestEnvironment) const TestingEnvironmentBanner(),
          Expanded(
            child: Container(
              padding: applyPadding ? const EdgeInsets.all(16) : null,
              color: backgroundColor,
              child: body,
            ),
          ),
        ],
      ),
    );
  }
}

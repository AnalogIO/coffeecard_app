import 'package:coffeecard/base/strings_environment.dart';
import 'package:coffeecard/base/style/app_colors.dart';
import 'package:coffeecard/base/style/app_text_styles.dart';
import 'package:coffeecard/features/environment/domain/entities/environment.dart';
import 'package:coffeecard/features/environment/presentation/cubit/environment_cubit.dart';
import 'package:coffeecard/widgets/components/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class EnvironmentButton extends StatelessWidget {
  const EnvironmentButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnvironmentCubit, EnvironmentState>(
      builder: (context, state) {
        final bool isTestEnvironment =
            state is EnvironmentLoaded && state.env.isTest;

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
                  TestEnvironmentStrings.description.first,
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
              backgroundColor: AppColors.white,
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
                  color: AppColors.primary,
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

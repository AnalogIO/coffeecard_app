import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/features/contributor/presentation/pages/credits_page.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:coffeecard/widgets/components/images/analogio_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class Footer extends StatelessWidget {
  const Footer();

  @override
  Widget build(BuildContext context) {
    final userId = switch (context.watch<UserCubit>().state) {
      UserLoaded(:final user) => user.id.toString(),
      _ => '...',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.push(context, CreditsPage.route).ignore(),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                Strings.madeBy,
                style: AppTextStyle.explainer,
                textAlign: TextAlign.center,
              ),
              const Gap(8),
              Text(
                '${Strings.userID}: $userId',
                style: AppTextStyle.explainer,
                textAlign: TextAlign.center,
              ),
              const Gap(24),
              const AnalogIOLogo.small(),
            ],
          ),
        ),
      ),
    );
  }
}

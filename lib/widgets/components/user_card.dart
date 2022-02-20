import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:coffeecard/widgets/routers/settings_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class UserCard extends StatelessWidget {
  const UserCard();

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Tappable(
        onTap: () => SettingsFlow.push(SettingsFlow.yourProfileRoute),
        borderRadius: BorderRadius.circular(24.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(),
              const Gap(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userCubit.state.user!.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.recieptItemKey,
                    ),
                    const Gap(3),
                    Text(
                      'BSWU student',
                      style: AppTextStyle.explainer,
                    ),
                  ],
                ),
              ),
              const Gap(16),
              const Icon(Icons.edit, color: AppColor.primary),
              const Gap(12),
            ],
          ),
        ),
      ),
    );
  }
}

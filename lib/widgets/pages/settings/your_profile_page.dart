import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/settings/settings_cubit.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:coffeecard/widgets/app_scaffold.dart';
import 'package:coffeecard/widgets/components/settings_group.dart';
import 'package:coffeecard/widgets/components/settings_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class YourProfilePage extends StatelessWidget {
  const YourProfilePage();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: Strings.yourProfilePageTitle,
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return (state.isLoaded)
              ? _EditProfile(state.user!)
              : const SizedBox.shrink();
        },
      ),
    );
  }
}

class _EditProfile extends StatelessWidget {
  final User user;

  const _EditProfile(this.user);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(24),
        const CircleAvatar(radius: 54),
        const Gap(12),
        Text(
          user.name,
          style: AppTextStyle.sectionTitle,
          textAlign: TextAlign.center,
        ),
        const Gap(8),
        Text('BSWU student', style: AppTextStyle.explainer),
        const Gap(24),
        SettingsGroup(
          title: Strings.settingsGroupProfile,
          listItems: [
            SettingListEntry(
              name: Strings.name,
              valueWidget: SettingDescription(text: user.name),
              onTap: () {},
            ),
            SettingListEntry(
              name: Strings.occupation,
              valueWidget: const SettingDescription(text: 'BSWU student'),
              onTap: () {},
            ),
            SettingListEntry(
              name: Strings.changeProfilePicture,
              valueWidget: const SettingDescription(),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/settings/settings_cubit.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:coffeecard/widgets/components/settings_group.dart';
import 'package:coffeecard/widgets/components/settings_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserCard extends StatelessWidget {
  final SettingsState state;

  const UserCard(this.state);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Tappable(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return Scaffold(
                  appBar: AppBar(title: const Text('Your profile')),
                  body: Center(child: EditProfile(state.user!)),
                );
              },
            ),
          );
        },
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
                      state.user!.name,
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

class EditProfile extends StatelessWidget {
  final User user;

  const EditProfile(this.user);

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
          title: 'Edit profile',
          listItems: [
            SettingListEntry(
              name: 'Name',
              valueWidget: SettingDescription(text: user.name),
              onTap: () {},
            ),
            SettingListEntry(
              name: 'Occupation',
              valueWidget: const SettingDescription(text: 'BSWU student'),
              onTap: () {},
            ),
            SettingListEntry(
              name: 'Change profile picture',
              valueWidget: const SettingDescription(),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

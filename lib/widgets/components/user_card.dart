import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/settings/settings_cubit.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:coffeecard/widgets/components/settings_group.dart';
import 'package:coffeecard/widgets/components/settings_list_entry.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final SettingsState state;

  const UserCard(this.state);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
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
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 12, right: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.user!.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.recieptItemKey,
                    ),
                    const Text(
                      'occupation',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor.secondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
              const Icon(Icons.edit)
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
        const Padding(
          padding: EdgeInsets.only(top: 25, bottom: 25),
          child: CircleAvatar(
            radius: 54,
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                user.name,
                style: AppTextStyle.sectionTitle,
                textAlign: TextAlign.center,
              ),
            ),
            const Text('occupation'),
          ],
        ),
        SettingsGroup(
          title: 'Edit profile',
          listItems: [
            SettingListEntry(
              name: 'Name',
              valueWidget: Text(
                user.name,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColor.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {},
            ),
            SettingListEntry(
              name: 'Occupation',
              valueWidget: const Text(
                'occ',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColor.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {},
            ),
            SettingListEntry(
              name: 'Change profile picture',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

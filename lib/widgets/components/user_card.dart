import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/blocs/settings/settings_bloc.dart';
import 'package:coffeecard/model/account/user.dart';
import 'package:coffeecard/widgets/components/setting_list_item.dart';
import 'package:coffeecard/widgets/components/settings_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'helpers/tappable.dart';

class UserCard extends StatelessWidget {
  final UserLoaded state;

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
                  body: Center(child: EditProfile(state.user)),
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
            children: [
              const CircleAvatar(),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.user.name,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColor.primary,
                              fontWeight: FontWeight.w800,
                            ),
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
                    const Icon(Icons.edit)
                  ],
                ),
              ),
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
        Column(children: [Text(user.name), const Text('occupation')]),
        SettingsGroup(
          title: 'Edit profile',
          listItems: [
            SettingListItem(
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
            SettingListItem(
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
            SettingListItem(
              name: 'Change profile picture',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

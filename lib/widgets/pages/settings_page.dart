import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserCard(),
        const Gap(16),
        SettingsGroup(
          title: 'Account',
          listItems: [
            SettingListItem(
              name: 'Email',
              value: 'email@example.com',
              onTap: () {},
            ),
            SettingListItem(
              name: 'Passcode',
              value: 'Change',
              onTap: () {},
            ),
            SettingListItem(
              name: 'Remove account',
              destructive: true,
              onTap: () {},
            ),
          ],
        )
      ],
    );
  }
}

class SettingsGroup extends StatelessWidget {
  final String title;
  final List<SettingListItem> listItems;
  const SettingsGroup({required this.title, required this.listItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(16),
        Text(title, style: AppTextStyle.sectionTitle),
        const Gap(8),
        Column(children: listItems)
      ],
    );
  }
}

class SettingListItem extends StatelessWidget {
  final String name;
  final String? value;
  final bool destructive;
  final void Function() onTap;

  const SettingListItem({
    required this.name,
    required this.onTap,
    this.value,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: onTap,
      child: Row(
        children: [
          Text(name),
          if (value == null) Container() else Text(value!),
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: () {},
      child: Card(
        child: Row(
          children: [
            const CircleAvatar(),
            Column(
              children: const [
                Text('name'),
                Text('occupation'),
              ],
            ),
            const Icon(Icons.edit),
          ],
        ),
      ),
    );
  }
}

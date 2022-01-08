import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/settings/settings_bloc.dart';
import 'package:coffeecard/data/repositories/v1/account_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsBloc(sl.get<AccountRepository>())..add(LoadUser()),
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const CircularProgressIndicator();
          } else if (state is UserLoaded) {
            return Column(
              children: [
                UserCard(state),
                const Gap(16),
                SettingsGroup(
                  title: 'Account',
                  listItems: [
                    SettingListItem(
                      name: 'Email',
                      value: state.user.email,
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
          } else {
            // TODO default?
            return const CircularProgressIndicator();
          }
        },
      ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
      color: AppColor.white,
      border: const Border(bottom: BorderSide(color: AppColor.lightGray)),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name),
            if (value == null) Container() else Text(value!),
          ],
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final UserLoaded state;

  const UserCard(this.state);

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: () {},
      child: Card(
        child: Row(
          children: [
            const CircleAvatar(),
            Column(
              children: [
                Text(state.user.name),
                const Text('occupation'),
              ],
            ),
            const Icon(Icons.edit),
          ],
        ),
      ),
    );
  }
}

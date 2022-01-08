import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/settings/settings_bloc.dart';
import 'package:coffeecard/data/repositories/v1/account_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/setting_list_item.dart';
import 'package:coffeecard/widgets/components/settings_group.dart';
import 'package:coffeecard/widgets/components/user_card.dart';
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
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: UserCard(state),
                ),
                const Gap(16),
                SettingsGroup(
                  title: 'Account',
                  listItems: [
                    SettingListItem(
                      name: 'Email',
                      valueWidget: Text(
                        state.user.email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColor.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {},
                    ),
                    SettingListItem(
                      name: 'Passcode',
                      valueWidget: const Text(
                        'Change',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {},
                    ),
                    SettingListItem(
                      name: 'Remove account',
                      destructive: true,
                      onTap: () {},
                    ),
                  ],
                ),
                SettingsGroup(
                  title: 'Features',
                  listItems: [
                    SettingListItem(
                      name: 'Sign in with fingerprint',
                      valueWidget: Switch(value: false, onChanged: (e) {}),
                      onTap: () {},
                    ),
                  ],
                ),
                SettingsGroup(
                  title: 'About Café Analog',
                  listItems: [
                    SettingListItem(
                      name: 'Frequently Asked Questions',
                      onTap: () {},
                    ),
                    SettingListItem(
                      name: 'Opening hours',
                      valueWidget: const Text(
                        'Today: 8-18',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColor.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
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

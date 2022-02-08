import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/cubits/settings/settings_cubit.dart';
import 'package:coffeecard/widgets/components/app_bar_title.dart';
import 'package:coffeecard/widgets/components/settings_group.dart';
import 'package:coffeecard/widgets/components/settings_list_entry.dart';
import 'package:coffeecard/widgets/components/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle('Settings'),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const CircularProgressIndicator();
          } else {
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
                    SettingListEntry(
                      name: 'Email',
                      valueWidget: Text(
                        state.user!.email,
                        style: AppTextStyle.settingValue,
                      ),
                      onTap: () {},
                    ),
                    SettingListEntry(
                      name: 'Passcode',
                      valueWidget: Text(
                        'Change',
                        style: AppTextStyle.settingValue,
                      ),
                      onTap: () {
                        // context.read<SettingsCubit>().changePasscode('0000');
                      },
                    ),
                    SettingListEntry(
                      name: 'Log out',
                      onTap: () {
                        context.read<AuthenticationCubit>().unauthenticated();
                      },
                    ),
                    SettingListEntry(
                      name: 'Remove account',
                      destructive: true,
                      onTap: () {},
                    ),
                  ],
                ),
                SettingsGroup(
                  title: 'Features',
                  listItems: [
                    SettingListEntry(
                      name: 'Sign in with fingerprint',
                      valueWidget: Switch(value: false, onChanged: (e) {}),
                      onTap: () {},
                    ),
                  ],
                ),
                SettingsGroup(
                  title: 'About Café Analog',
                  listItems: [
                    SettingListEntry(
                      name: 'Frequently Asked Questions',
                      onTap: () {},
                    ),
                    SettingListEntry(
                      name: 'Opening hours',
                      valueWidget: Text(
                        'Today: 8-18',
                        style: AppTextStyle.settingValue,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

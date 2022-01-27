import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/cubits/settings/settings_cubit.dart';
import 'package:coffeecard/data/repositories/v1/account_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/widgets/components/app_bar_title.dart';
import 'package:coffeecard/widgets/components/settings_group.dart';
import 'package:coffeecard/widgets/components/settings_list_entry.dart';
import 'package:coffeecard/widgets/components/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle('Settings'),
      ),
      body: BlocProvider(
        create: (_) => SettingsCubit(sl.get<AccountRepository>())..loadUser(),
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const CircularProgressIndicator();
            } else {
              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 16),
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
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColor.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: () {},
                      ),
                      SettingListEntry(
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
            }
          },
        ),
      ),
    );
  }
}

import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/cubits/settings/settings_cubit.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/settings_group.dart';
import 'package:coffeecard/widgets/components/settings_list_entry.dart';
import 'package:coffeecard/widgets/components/user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage();

  String get userId => '1234';

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.settingsPageTitle,
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const CircularProgressIndicator();
          } else {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: UserCard(state),
                ),
                const Gap(16),
                SettingsGroup(
                  title: Strings.settingsGroupAccount,
                  listItems: [
                    SettingListEntry(
                      name: Strings.email,
                      valueWidget: Text(
                        state.user!.email,
                        style: AppTextStyle.settingValue,
                      ),
                      onTap: () {},
                    ),
                    SettingListEntry(
                      name: Strings.passcode,
                      valueWidget: Text(
                        Strings.change,
                        style: AppTextStyle.settingValue,
                      ),
                      onTap: () {
                        // context.read<SettingsCubit>().changePasscode('0000');
                      },
                    ),
                    SettingListEntry(
                      name: Strings.logOut,
                      onTap: () {
                        context.read<AuthenticationCubit>().unauthenticated();
                      },
                    ),
                    SettingListEntry(
                      name: Strings.deleteAccount,
                      destructive: true,
                      onTap: () {},
                    ),
                  ],
                ),
                SettingsGroup(
                  title: Strings.settingsGroupFeatures,
                  listItems: [
                    SettingListEntry(
                      name: Strings.signInWithFingerprint,
                      valueWidget: Switch(value: false, onChanged: (e) {}),
                      onTap: () {},
                    ),
                  ],
                ),
                SettingsGroup(
                  title: Strings.settingsGroupAbout,
                  listItems: [
                    SettingListEntry(
                      name: Strings.faq,
                      onTap: () {},
                    ),
                    SettingListEntry(
                      name: Strings.openingHours,
                      valueWidget: Text(
                        // TODO: Could show tomorrow's opening hours
                        // if we are closed today
                        '${Strings.today}: 8-18',
                        style: AppTextStyle.settingValue,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                const Gap(24),
                Text(
                  Strings.madeBy,
                  style: AppTextStyle.explainer,
                  textAlign: TextAlign.center,
                ),
                const Gap(8),
                Text(
                  '${Strings.userID}: $userId',
                  style: AppTextStyle.explainer,
                  textAlign: TextAlign.center,
                ),
                const Gap(24),
              ],
            );
          }
        },
      ),
    );
  }
}

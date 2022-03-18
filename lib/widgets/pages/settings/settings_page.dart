import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/widgets/components/dialog.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/settings_group.dart';
import 'package:coffeecard/widgets/components/settings_list_entry.dart';
import 'package:coffeecard/widgets/components/user_card.dart';
import 'package:coffeecard/widgets/pages/settings/change_email_page.dart';
import 'package:coffeecard/widgets/pages/settings/change_passcode_page.dart';
import 'package:coffeecard/widgets/routers/settings_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage();

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.settingsPageTitle,
      body: BlocBuilder<UserCubit, UserState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is! UserLoaded) {
            return Column(
              children: const [LinearProgressIndicator()],
            );
          }
          return ListView(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: UserCard(),
              ),
              SettingsGroup(
                title: Strings.settingsGroupAccount,
                listItems: [
                  SettingListEntry(
                    name: Strings.email,
                    valueWidget: Text(
                      state.user.email,
                      style: AppTextStyle.settingValue,
                    ),
                    onTap: () {
                      SettingsFlow.push(
                        ChangeEmailPage(currentEmail: state.user.email),
                      );
                    },
                  ),
                  SettingListEntry(
                    name: Strings.passcode,
                    valueWidget: Text(
                      Strings.change,
                      style: AppTextStyle.settingValue,
                    ),
                    onTap: () => SettingsFlow.push(const ChangePasscodePage()),
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
                    onTap: () {
                      _showDeleteAccountDialog(context, state.user.email);
                    },
                  ),
                ],
              ),
              const SettingsGroup(
                title: Strings.settingsGroupAbout,
                listItems: [
                  SettingListEntry(
                    name: Strings.faq,
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
                '${Strings.userID}: ${state.user.id}',
                style: AppTextStyle.explainer,
                textAlign: TextAlign.center,
              ),
              const Gap(24),
            ],
          );
        },
      ),
    );
  }
}

void _showDeleteAccountDialog(BuildContext context, String email) {
  appDialog(
    context: context,
    title: Strings.deleteAccount,
    children: const [Text(Strings.deleteAccountText)],
    actions: <Widget>[
      TextButton(
        child: const Text(
          Strings.buttonUnderstand,
          style: TextStyle(color: AppColor.error),
        ),
        onPressed: () {
          context.read<UserCubit>().requestAccountDeletion();

          closeAppDialog(context);
          appDialog(
            context: context,
            title: Strings.deleteAccount,
            children: [Text(Strings.deleteAccountEmailConfirmation(email))],
            actions: [
              TextButton(
                child: const Text(Strings.buttonOK),
                onPressed: () => closeAppDialog(context),
              ),
            ],
            dismissible: false,
          );
        },
      ),
      TextButton(
        onPressed: () => closeAppDialog(context),
        child: const Text(Strings.buttonCancel),
      ),
    ],
    dismissible: true,
  );
}

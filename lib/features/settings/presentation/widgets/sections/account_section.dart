import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/widgets/components/dialog.dart';
import 'package:coffeecard/core/widgets/components/helpers/shimmer_builder.dart';
import 'package:coffeecard/features/authentication/presentation/cubits/authentication_cubit.dart';
import 'package:coffeecard/features/settings/presentation/pages/change_email_page.dart';
import 'package:coffeecard/features/settings/presentation/widgets/change_passcode_flow.dart';
import 'package:coffeecard/features/settings/presentation/widgets/session_timeout_dropdown.dart';
import 'package:coffeecard/features/settings/presentation/widgets/setting_value_text.dart';
import 'package:coffeecard/features/settings/presentation/widgets/settings_group.dart';
import 'package:coffeecard/features/settings/presentation/widgets/settings_list_entry.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountSection extends StatelessWidget {
  const AccountSection();

  void changeEmailTapCallback(BuildContext context, UserLoaded loadedState) {
    Navigator.push(
      context,
      ChangeEmailPage.routeWith(currentEmail: loadedState.user.email),
    ).ignore();
  }

  void changePasscodeTapCallback(BuildContext context, UserLoaded _) =>
      Navigator.push(context, ChangePasscodeFlow.route);

  void logoutTapCallback(BuildContext context) {
    context.read<AuthenticationCubit>().unauthenticated();
  }

  void deleteAccountTapCallback(BuildContext context, UserLoaded loadedState) {
    _showDeleteAccountDialog(context, loadedState.user.email);
  }

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserCubit>().state;

    return SettingsGroup(
      title: Strings.settingsGroupAccount,
      listItems: [
        SettingListEntry(
          name: Strings.email,
          valueWidget: ShimmerBuilder(
            showShimmer: userState is! UserLoaded,
            builder: (context, colorIfShimmer) {
              return ColoredBox(
                color: colorIfShimmer,
                child: SettingValueText(
                  value: (userState is UserLoaded)
                      ? userState.user.email
                      : Strings.emailShimmerText,
                ),
              );
            },
          ),
          onTap: _tappableIfUserLoaded(context, changeEmailTapCallback),
          // },
        ),
        SettingListEntry(
          name: Strings.passcode,
          valueWidget: const SettingValueText(
            value: Strings.change,
          ),
          onTap: _tappableIfUserLoaded(context, changePasscodeTapCallback),
        ),
        SettingListEntry(
          name: Strings.sessionTimeout,
          valueWidget: SessionTimeoutDropdown(
            selectedDuration: context
                .read<AuthenticationCubit>()
                .state
                .authenticatedUser
                ?.sessionTimeout,
          ),
          overrideDisableBehaviour: true,
        ),
        SettingListEntry(
          name: Strings.logOut,
          onTap: () => logoutTapCallback(context),
        ),
        SettingListEntry(
          name: Strings.deleteAccount,
          destructive: true,
          onTap: _tappableIfUserLoaded(context, deleteAccountTapCallback),
        ),
      ],
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
          style: TextStyle(color: AppColors.errorOnBright),
        ),
        onPressed: () {
          context.read<UserCubit>().requestUserAccountDeletion();

          closeAppDialog(context);
          appDialog(
            context: context,
            title: Strings.deleteAccount,
            children: [Text(Strings.deleteAccountEmailConfirmation(email))],
            actions: [
              TextButton(
                child: const Text(Strings.buttonOK),
                onPressed: () {
                  closeAppDialog(context);
                  context.read<AuthenticationCubit>().unauthenticated();
                },
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

/// Returns the given callback if the user data has been loaded, otherwise
/// returns null.
void Function()? _tappableIfUserLoaded(
  BuildContext context,
  void Function(BuildContext context, UserLoaded loadedState) callback,
) {
  return switch (context.read<UserCubit>().state) {
    final UserLoaded loadedState => () => callback(context, loadedState),
    _ => null,
  };
}

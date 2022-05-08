import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/widgets/components/dialog.dart';
import 'package:coffeecard/widgets/components/helpers/shimmer_builder.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/settings_group.dart';
import 'package:coffeecard/widgets/components/settings_list_entry.dart';
import 'package:coffeecard/widgets/components/user_card.dart';
import 'package:coffeecard/widgets/pages/settings/change_email_page.dart';
import 'package:coffeecard/widgets/pages/settings/change_passcode_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({required this.scrollController});

  final ScrollController scrollController;

  static Route routeWith({required ScrollController scrollController}) =>
      MaterialPageRoute(
        builder: (_) => SettingsPage(scrollController: scrollController),
      );

  /// `null` if `state is! Userloaded`, otherwise `callback(UserLoaded state)`.
  void Function()? _ifLoaded(
    UserState state,
    void Function(UserLoaded) callback,
  ) {
    return (state is! UserLoaded) ? null : () => callback(state);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.settingsPageTitle,
      body: BlocBuilder<UserCubit, UserState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return ListView(
            controller: scrollController,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: (state is UserLoaded)
                    ? UserCard(
                        name: state.user.name,
                        occupation: state.user.programme.fullName,
                      )
                    : const UserCard.placeholder(),
              ),
              SettingsGroup(
                title: Strings.settingsGroupAccount,
                listItems: [
                  SettingListEntry(
                    name: Strings.email,
                    valueWidget: ShimmerBuilder(
                      showShimmer: state is! UserLoaded,
                      builder: (context, colorIfShimmer) {
                        return Container(
                          color: colorIfShimmer,
                          child: Text(
                            (state is UserLoaded)
                                ? state.user.email
                                : 'Loading...',
                            style: AppTextStyle.settingValue,
                          ),
                        );
                      },
                    ),
                    onTap: _ifLoaded(
                      state,
                      (st) => Navigator.push(
                        context,
                        ChangeEmailPage.routeWith(currentEmail: st.user.email),
                      ),
                    ),
                    // },
                  ),
                  SettingListEntry(
                    name: Strings.passcode,
                    valueWidget: Text(
                      Strings.change,
                      style: AppTextStyle.settingValue,
                    ),
                    onTap: _ifLoaded(
                      state,
                      (_) => Navigator.push(
                        context,
                        ChangePasscodePage.route,
                      ),
                    ),
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
                    onTap: _ifLoaded(
                      state,
                      (st) => _showDeleteAccountDialog(context, st.user.email),
                    ),
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
                '${Strings.userID}: ${state is UserLoaded ? state.user.id : '...'}',
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
          style: TextStyle(color: AppColor.errorOnBright),
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

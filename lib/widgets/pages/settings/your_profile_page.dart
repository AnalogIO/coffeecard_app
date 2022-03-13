import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:coffeecard/utils/responsive.dart';
import 'package:coffeecard/widgets/components/loading.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/settings_group.dart';
import 'package:coffeecard/widgets/components/settings_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class YourProfilePage extends StatelessWidget {
  const YourProfilePage();

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.yourProfilePageTitle,
      body: BlocBuilder<UserCubit, UserState>(
        buildWhen: (_, current) => current is UserLoaded,
        builder: (_, userLoadedState) {
          if (userLoadedState is! UserLoaded) return const SizedBox.shrink();

          return BlocBuilder<UserCubit, UserState>(
            buildWhen: (previous, current) =>
                previous is UserUpdating || current is UserUpdating,
            builder: (context, state) {
              return Loading(
                loading: state is UserUpdating,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 36),
                  child: _EditProfile(user: userLoadedState.user),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _EditProfile extends StatelessWidget {
  const _EditProfile({required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const CircularProgressIndicator();
        } else if (state is UserError) {
          //FIXME: display error page?
          return const SizedBox.shrink();
        } else if (state is UserLoaded) {
          return Column(
            children: [
              const Gap(24),
              const CircleAvatar(radius: 54),
              const Gap(12),
              Text(
                user.name,
                style: AppTextStyle.sectionTitle,
                textAlign: TextAlign.center,
              ),
              const Gap(8),
<<<<<<< HEAD
              Text(
                '${state.user.programme.fullName} (${state.user.programme.shortName})',
                style: AppTextStyle.explainer,
              ),
=======
              //FIXME: lookup on programme id
              Text('${state.user.programmeId}', style: AppTextStyle.explainer),
>>>>>>> Move user information to cubit (#157)
              const Gap(24),
              SettingsGroup(
                title: Strings.settingsGroupProfile,
                listItems: [
                  SettingListEntry(
                    name: Strings.name,
                    valueWidget: SettingDescription(text: user.name),
                    onTap: () {},
                  ),
                  SettingListEntry(
                    name: Strings.occupation,
<<<<<<< HEAD
                    valueWidget: SettingDescription(
                      text: state.user.programme.shortName,
                    ),
=======
                    //FIXME: lookup on programme id
                    valueWidget:
                        SettingDescription(text: '${state.user.programmeId}'),
>>>>>>> Move user information to cubit (#157)
                    onTap: () {},
                  ),
                  SettingListEntry(
                    name: Strings.changeProfilePicture,
                    valueWidget: const SettingDescription(),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          );
        }

        throw MatchCaseIncompleteException(this);
      },
=======
    return Column(
      children: [
        const Gap(24),
        const CircleAvatar(radius: 54),
        const Gap(12),
        Text(
          user.name,
          style: AppTextStyle.sectionTitle,
          textAlign: TextAlign.center,
        ),
        const Gap(8),
        //FIXME: lookup on programme id
        Text('${user.programmeId}', style: AppTextStyle.explainer),
        const Gap(24),
        SettingsGroup(
          title: Strings.settingsGroupProfile,
          description: Strings.yourProfileDescription,
          listItems: [
            SettingListEntry(
              name: Strings.name,
              valueWidget: SettingDescription(text: user.name),
              onTap: () {},
            ),
            SettingListEntry(
              name: Strings.occupation,
              //FIXME: lookup on programme id
              valueWidget: SettingDescription(text: '${user.programmeId}'),
              onTap: () {},
            ),
            SettingListEntry(
              name: Strings.changeProfilePicture,
              valueWidget: const SettingDescription(),
              onTap: () {},
            ),
            SettingListEntry(
              name: deviceIsSmall(context)
                  ? Strings.appearAnonymousSmall
                  : Strings.appearAnonymous,
              valueWidget: Switch(
                value: user.privacyActivated,
                onChanged: (privacyActived) async {
                  await context
                      .read<UserCubit>()
                      .setUserPrivacy(privacyActived: privacyActived);
                },
              ),
            ),
          ],
        ),
      ],
>>>>>>> Add option to appear anonymous (#175)
    );
  }
}

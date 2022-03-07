import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:coffeecard/utils/responsive.dart';
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

class Loading extends StatelessWidget {
  const Loading({Key? key, required this.loading, required this.child})
      : super(key: key);

  final bool loading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: loading,
      child: Stack(
        children: [
          if (loading) const LinearProgressIndicator(),
          AnimatedOpacity(
            opacity: loading ? 0.4 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _EditProfile extends StatelessWidget {
  final User user;

  const _EditProfile({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          description: 'These settings affect your appearance in Leaderboards.',
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
                onChanged: (v) async {
                  await context
                      .read<UserCubit>()
                      .setUserPrivacy(privacyActived: v);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

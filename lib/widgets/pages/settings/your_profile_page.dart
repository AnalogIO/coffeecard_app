import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:coffeecard/utils/page_pusher.dart';
import 'package:coffeecard/utils/responsive.dart';
import 'package:coffeecard/widgets/components/entry/register/name_body.dart';
import 'package:coffeecard/widgets/components/list_entry.dart';
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
            buildWhen: (previous, current) => previous is UserUpdating || current is UserUpdating,
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
        Text(
          '${user.programme.fullName} (${user.programme.shortName})',
          style: AppTextStyle.explainer,
        ),
        const Gap(24),
        SettingsGroup(
          title: Strings.settingsGroupProfile,
          listItems: [
            SettingListEntry(
              name: Strings.name,
              valueWidget: SettingDescription(text: user.name),
              onTap: () => _pushChangeNamePage(context),
            ),
            SettingListEntry(
              name: Strings.occupation,
              valueWidget: SettingDescription(
                text: user.programme.shortName,
              ),
              onTap: () => _pushChangeProgrammePage(context),
            ),
            SettingListEntry(
              name: deviceIsSmall(context) ? Strings.appearAnonymousSmall : Strings.appearAnonymous,
              onTap: () => context.read<UserCubit>().setUserPrivacy(privacyActivated: !user.privacyActivated),
              valueWidget: Switch(
                value: user.privacyActivated,
                onChanged: (_) {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pushChangeNamePage(BuildContext context) {
    return pushPageScaffold(
      context: context,
      title: Strings.changeName,
      body: NameBody(
        initialValue: user.name,
        onSubmit: (context, name) {
          context.read<UserCubit>().setUserName(name);
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _pushChangeProgrammePage(BuildContext context) {
    return pushPageScaffold(
      context: context,
      title: Strings.changeProgramme,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            return ListView.builder(
              itemCount: state.programmes.length,
              itemBuilder: (context, index) {
                state.programmes.sort((a, b) => a.fullName!.compareTo(b.fullName!));
                final programme = state.programmes[index];
                return ListEntry(
                  leftWidget: SizedBox(
                    //TODO Is there a better way to determine the width of the left widget
                    width: MediaQuery.of(context).size.width * (3 / 5),
                    child: Text(programme.fullName!),
                  ),
                  rightWidget: Text(programme.shortName!),
                  onTap: () {
                    context.read<UserCubit>().setUserProgramme(programme.id!);
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
          //TODO handle programmes not being loaded?
          return const Text('Error');
        },
      ),
    );
  }
}

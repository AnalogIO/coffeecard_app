import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/models/account/user.dart';
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
        builder: (context, state) {
          if (state is UserLoading) {
            return const SizedBox.shrink();
          } else if (state is UserLoaded) {
            return _EditProfile(state.user);
          } else if (state is UserError) {
            //FIXME: display error
            return const SizedBox.shrink();
          }

          throw MatchCaseIncompleteException(this);
        },
      ),
    );
  }
}

class _EditProfile extends StatelessWidget {
  final User user;

  const _EditProfile(this.user);

  @override
  Widget build(BuildContext context) {
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
              //FIXME: lookup on programme id
              Text('${state.user.programmeId}', style: AppTextStyle.explainer),
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
                    //FIXME: lookup on programme id
                    valueWidget:
                        SettingDescription(text: '${state.user.programmeId}'),
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
    );
  }
}

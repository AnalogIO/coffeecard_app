import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/features/occupation/presentation/pages/change_occupation_page.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:coffeecard/utils/responsive.dart';
import 'package:coffeecard/widgets/components/loading.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/settings_group.dart';
import 'package:coffeecard/widgets/components/settings_list_entry.dart';
import 'package:coffeecard/widgets/components/user/user_icon.dart';
import 'package:coffeecard/widgets/pages/settings/change_name_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class YourProfilePage extends StatelessWidget {
  const YourProfilePage();

  static Route get route =>
      MaterialPageRoute(builder: (_) => const YourProfilePage());

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
    final occupationShotName = user.occupation.shortName;
    return Column(
      children: [
        const Gap(24),
        UserIcon.large(id: user.id),
        const Gap(12),
        Text(
          user.name,
          style: AppTextStyle.sectionTitle,
          textAlign: TextAlign.center,
        ),
        const Gap(8),
        Text(
          '${user.occupation.fullName} ($occupationShotName)',
          style: AppTextStyle.explainer,
        ),
        const Gap(24),
        SettingsGroup(
          title: Strings.settingsGroupProfile,
          listItems: [
            SettingListEntry(
              name: Strings.name,
              valueWidget: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: SettingDescription(text: user.name),
              ),
              onTap: () => Navigator.push(
                context,
                ChangeNamePage.routeWith(name: user.name),
              ),
            ),
            SettingListEntry(
              name: Strings.occupation,
              valueWidget: SettingDescription(
                text: occupationShotName,
              ),
              onTap: () => Navigator.push(context, ChangeOccupationPage.route),
            ),
            SettingListEntry(
              name: deviceIsSmall(context)
                  ? Strings.appearAnonymousSmall
                  : Strings.appearAnonymous,
              onTap: () => context
                  .read<UserCubit>()
                  .setUserPrivacy(privacyActivated: !user.privacyActivated),
              valueWidget: Switch(
                value: user.privacyActivated,
                //No action needed on change, only tap
                //ignore: no-empty-block
                onChanged: (_) {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

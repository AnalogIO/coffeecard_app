import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/coffee_card_switch.dart';
import 'package:coffeecard/core/widgets/components/helpers/responsive.dart';
import 'package:coffeecard/features/occupation/presentation/pages/change_occupation_page.dart';
import 'package:coffeecard/features/settings/presentation/pages/change_name_page.dart';
import 'package:coffeecard/features/settings/presentation/widgets/setting_description.dart';
import 'package:coffeecard/features/settings/presentation/widgets/settings_group.dart';
import 'package:coffeecard/features/settings/presentation/widgets/settings_list_entry.dart';
import 'package:coffeecard/features/settings/presentation/widgets/user_icon.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final occupationShortName = user.occupation.shortName;
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
          '${user.occupation.fullName} ($occupationShortName)',
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
                text: occupationShortName,
              ),
              onTap: () => Navigator.push(context, ChangeOccupationPage.route),
            ),
            SettingListEntry(
              name: deviceIsSmall(context)
                  ? Strings.appearAnonymousSmall
                  : Strings.appearAnonymous,
              valueWidget: CoffeeCardSwitch(
                value: user.privacyActivated,
                onChanged: (toggled) => context
                    .read<UserCubit>()
                    .setUserPrivacy(privacyActivated: toggled),
              ),
              overrideDisableBehaviour: true,
            ),
          ],
        ),
      ],
    );
  }
}

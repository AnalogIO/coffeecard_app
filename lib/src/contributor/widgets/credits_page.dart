import 'package:coffeecard/core/api_uri_constants.dart';
import 'package:coffeecard/core/external/external_url_launcher.dart';
import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/scaffold.dart';
import 'package:coffeecard/core/widgets/components/section_title.dart';
import 'package:coffeecard/core/widgets/images/analogio_logo.dart';
import 'package:coffeecard/features/contributor.dart';
import 'package:coffeecard/features/settings/presentation/widgets/settings_group.dart';
import 'package:coffeecard/features/settings/presentation/widgets/settings_list_entry.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// FIXME: If this widget belongs here, then the feature should be renamed to
//  "credits" and this feature should contain more than just the contributors.
class CreditsPage extends StatelessWidget {
  static Route get route => MaterialPageRoute(builder: (_) => CreditsPage());

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.credits,
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: SectionTitle(Strings.developmentTeam),
              ),
              ...allContributors.map(ContributorCard.new),
            ],
          ),
          const AboutAnalogIO(),
          const Licenses(),
          const Gap(36),
        ],
      ),
    );
  }
}

class AboutAnalogIO extends StatelessWidget {
  const AboutAnalogIO();

  @override
  Widget build(BuildContext context) {
    return SettingsGroup(
      title: Strings.aboutAnalogIO,
      listItems: [
        DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(bottom: BorderSide(color: AppColors.lightGray)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Strings.analogIOBody,
                  overflow: TextOverflow.visible,
                  style: AppTextStyle.settingKey,
                ),
                const Gap(24),
                const AnalogIOLogo.large(),
              ],
            ),
          ),
        ),
        SettingListEntry(
          name: Strings.github,
          onTap: () => sl<ExternalUrlLauncher>().launchUrlExternalApplication(
            ApiUriConstants.analogIOGitHub,
            context,
          ),
        ),
      ],
    );
  }
}

class Licenses extends StatelessWidget {
  const Licenses();

  @override
  Widget build(BuildContext context) {
    return SettingsGroup(
      title: Strings.licenses,
      listItems: [
        SettingListEntry(
          name: Strings.viewLicenses,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LicensePage()),
          ),
        ),
      ],
    );
  }
}

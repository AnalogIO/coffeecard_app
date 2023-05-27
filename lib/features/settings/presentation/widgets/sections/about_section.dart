import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/core/external/external_url_launcher.dart';
import 'package:coffeecard/features/contributor/presentation/pages/credits_page.dart';
import 'package:coffeecard/features/settings/presentation/pages/faq_page.dart';
import 'package:coffeecard/features/settings/presentation/widgets/setting_value_text.dart';
import 'package:coffeecard/features/settings/presentation/widgets/settings_group.dart';
import 'package:coffeecard/features/settings/presentation/widgets/settings_list_entry.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/api_uri_constants.dart';
import 'package:flutter/material.dart';

class AboutSection extends StatelessWidget {
  const AboutSection();

  void faqTapCallback(BuildContext context) {
    Navigator.push(context, FAQPage.route).ignore();
  }

  void privacyPolicyTapCallback(BuildContext context) {
    sl<ExternalUrlLauncher>().launchUrlExternalApplication(
      ApiUriConstants.privacyPolicyUri,
      context,
    );
  }

  void provideFeedbackTapCallback(BuildContext context) {
    sl<ExternalUrlLauncher>().launchUrlExternalApplication(
      ApiUriConstants.feedbackFormUri,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SettingsGroup(
      title: Strings.settingsGroupAbout,
      listItems: [
        SettingListEntry(
          name: Strings.frequentlyAskedQuestions,
          onTap: () => faqTapCallback(context),
        ),
        const SettingListEntry(
          name: Strings.openingHours,
          valueWidget: SettingValueText(
            value: Strings.notAvailable,
          ),
        ),
        SettingListEntry(
          name: Strings.privacyPolicy,
          onTap: () => privacyPolicyTapCallback(context),
        ),
        SettingListEntry(
          name: Strings.provideFeedback,
          onTap: () => provideFeedbackTapCallback(context),
        ),
        SettingListEntry(
          name: Strings.credits,
          onTap: () => Navigator.push(context, CreditsPage.route).ignore(),
        ),
      ],
    );
  }
}

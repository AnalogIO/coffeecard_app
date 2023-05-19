import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/core/external/external_url_launcher.dart';
import 'package:coffeecard/features/contributor/presentation/cubit/contributor_cubit.dart';
import 'package:coffeecard/features/contributor/presentation/widgets/contributor_card.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/api_uri_constants.dart';
import 'package:coffeecard/widgets/components/images/analogio_logo.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/section_title.dart';
import 'package:coffeecard/widgets/components/settings_group.dart';
import 'package:coffeecard/widgets/components/settings_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class CreditsPage extends StatelessWidget {
  static Route get route => MaterialPageRoute(builder: (_) => CreditsPage());

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.credits,
      body: BlocProvider(
        create: (_) => sl<ContributorCubit>()..getContributors(),
        child: ListView(
          children: [
            BlocBuilder<ContributorCubit, ContributorState>(
              builder: (context, state) {
                if (state is ContributorInitial) {
                  return const SizedBox.shrink();
                }

                if (state is ContributorLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(16),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: SectionTitle(Strings.developmentTeam),
                      ),
                      ...state.contributors.map((e) => ContributorCard(e)),
                    ],
                  );
                }

                throw ArgumentError(this);
              },
            ),
            SettingsGroup(
              title: Strings.aboutAnalogIO,
              listItems: [
                DecoratedBox(
                  decoration: const BoxDecoration(
                    color: AppColor.white,
                    border:
                        Border(bottom: BorderSide(color: AppColor.lightGray)),
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
                  onTap: () =>
                      sl<ExternalUrlLauncher>().launchUrlExternalApplication(
                    ApiUriConstants.analogIOGitHub,
                    context,
                  ),
                ),
              ],
            ),
            SettingsGroup(
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
            ),
            const Gap(36),
          ],
        ),
      ),
    );
  }
}

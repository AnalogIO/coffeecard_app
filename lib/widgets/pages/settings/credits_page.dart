import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/contributor/contributor_cubit.dart';
import 'package:coffeecard/data/api/coffee_card_api_constants.dart';
import 'package:coffeecard/data/repositories/external/contributor_repository.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/launch.dart';
import 'package:coffeecard/widgets/components/contributor_card.dart';
import 'package:coffeecard/widgets/components/error_section.dart';
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
        create: (context) => ContributorCubit(sl.get<ContributorRepository>())
          ..getContributors(),
        child: ListView(
          children: [
            BlocBuilder<ContributorCubit, ContributorState>(
              builder: (context, state) {
                if (state is ContributorLoading) {
                  return const LinearProgressIndicator();
                } else if (state is ContributorLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(16),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: SectionTitle(Strings.appTeam),
                      ),
                      ...state.contributors.map((e) => ContributorCard(e))
                    ],
                  );
                } else if (state is ContributorError) {
                  return ErrorSection(
                    center: true,
                    error: state.error,
                    retry: context.read<ContributorCubit>().getContributors,
                  );
                }

                throw MatchCaseIncompleteException(this);
              },
            ),
            SettingsGroup(
              title: Strings.aboutAnalogIO,
              listItems: [
                Container(
                  decoration: const BoxDecoration(
                    color: AppColor.white,
                    border:
                        Border(bottom: BorderSide(color: AppColor.lightGray)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AnalogIOLogo(),
                        const Gap(24),
                        Flexible(
                          child: Text(
                            Strings.analogIOBody,
                            overflow: TextOverflow.visible,
                            style: AppTextStyle.settingKey,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SettingListEntry(
                  name: Strings.github,
                  onTap: () => launchUrlExternalApplication(
                    ApiUriConstants.analogIOGitHub,
                    context,
                  ),
                ),
                SettingListEntry(
                  name: Strings.provideFeedback,
                  onTap: () => launchUrlExternalApplication(
                    ApiUriConstants.feedbackFormUri,
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

import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/widgets/components/app_bar_title.dart';
import 'package:coffeecard/widgets/components/dropdowns/statistics_dropdown.dart';
import 'package:coffeecard/widgets/components/left_aligned_text.dart';
import 'package:coffeecard/widgets/components/list_entry.dart';
import 'package:coffeecard/widgets/components/receipt/filter_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class StatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(Strings.statsPageTitle),
      ),
      body: BlocBuilder<StatisticsCubit, StatisticsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const CircularProgressIndicator();
          } else {
            return RefreshIndicator(
              displacement: 24,
              onRefresh: context.read<StatisticsCubit>().fetchLeaderboards,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        LeftAlignedText(
                          Strings.statisticsYourStats,
                          style: AppTextStyle.sectionTitle,
                        ),
                        const Gap(10),
                        LeftAlignedText(
                          '${state.user?.name}',
                          style: AppTextStyle.textField,
                        ),
                        LeftAlignedText(
                          '${state.user?.email}',
                          style: AppTextStyle.textField,
                        ),
                        LeftAlignedText(
                          'ID: ${state.user?.id}',
                          style: AppTextStyle.textField,
                        ),
                        const Gap(10),
                        LeftAlignedText(
                          Strings.statisticsLeaderboards,
                          style: AppTextStyle.sectionTitle,
                        ),
                      ],
                    ),
                  ),
                  FilterBar(
                    title: Strings.filter,
                    dropdown: StatisticsDropdown(),
                  ),
                  ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: state.leaderboard.length,
                    itemBuilder: (context, index) {
                      final entry = state.leaderboard[index];
                      return ListEntry(
                        leftWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(formatRank(index + 1)),
                            const Gap(10),
                            const CircleAvatar(),
                            const Gap(10),
                            //FIXME: programme not available yet, uncomment once it is
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LeftAlignedText(
                                  entry.name!,
                                  style: AppTextStyle.textField,
                                ),
                                LeftAlignedText(
                                  'programme',
                                  style: AppTextStyle.label,
                                ),
                              ],
                            ),
                          ],
                        ),
                        rightWidget: Text('${entry.score} cups'),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

String formatRank(int rank) {
  final rankStr = rank.toString();
  final lastDigit = rankStr[rankStr.length - 1];

  String postfix = 'th';
  switch (lastDigit) {
    case '1':
      postfix = 'st';
      break;
    case '2':
      postfix = 'nd';
      break;
    case '3':
      postfix = 'rd';
      break;
  }

  return '$rank$postfix';
}

/*
LeftAlignedText(
  Strings.statisticsQuickstats,
  style: AppTextStyle.sectionTitle,
),
StatisticsCard(
  Strings.statisticsTotalCupsDrunk,
  '53',
),
StatisticsCard(
  Strings.statisticsTotalCupsDrunkITU,
  '106',
),
StatisticsCard(
 Strings.statisticsYourRankITU,
 '125th',
),
StatisticsCard(
  Strings.statisticsYourRankProgramme('BSWU'),
  '62nd',
),
*/

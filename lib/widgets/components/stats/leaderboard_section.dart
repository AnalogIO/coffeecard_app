import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/receipt/filter_bar.dart';
import 'package:coffeecard/widgets/components/section_title.dart';
import 'package:coffeecard/widgets/components/stats/leaderboard_list_view.dart';
import 'package:coffeecard/widgets/components/stats/statistics_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LeaderboardSection extends StatelessWidget {
  const LeaderboardSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Gap(16),
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: SectionTitle(Strings.statsLeaderboards),
        ),
        FilterBar(
          title: Strings.statsShowTopDrinkerFor,
          dropdown: StatisticsDropdown(),
        ),
        const LeaderboardListView(),
      ],
    );
  }
}

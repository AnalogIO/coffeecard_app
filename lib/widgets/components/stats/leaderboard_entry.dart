import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/list_entry.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LeaderboardEntry extends StatelessWidget {
  final String name;
  final int score;
  final int rank;
  final bool highlight;

  const LeaderboardEntry(
    this.name,
    this.score,
    this.rank, {
    required this.highlight,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListEntry(
      backgroundColor: highlight ? AppColor.slightlyHighlighted : null,
      leftWidget: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('$rank${Strings.formatLeaderboardPostfix(rank)}'),
          const Gap(10),
          const CircleAvatar(),
          const Gap(10),
          Text(
            name,
            style: AppTextStyle.textField,
          ),
        ],
      ),
      rightWidget: Text('$score cups'),
    );
  }
}

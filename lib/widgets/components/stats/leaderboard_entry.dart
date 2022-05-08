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

  String get _scoreText =>
      '$score ${score != 1 ? Strings.statCups : Strings.statCup}';

  @override
  Widget build(BuildContext context) {
    return ListEntry(
      backgroundColor: highlight ? AppColor.slightlyHighlighted : null,
      leftWidget: Row(
        children: [
          _LeaderboardRankMedal(rank),
          const Gap(16),
          const CircleAvatar(),
          const Gap(8),
          Text(
            name,
            style: AppTextStyle.textField,
          ),
        ],
      ),
      rightWidget: Text(_scoreText),
    );
  }
}

class _LeaderboardRankMedal extends StatelessWidget {
  const _LeaderboardRankMedal(this.rank);
  final int rank;

  Color get _fillColor {
    if (rank == 1) return AppColor.goldMedal;
    if (rank == 2) return AppColor.silverMedal;
    if (rank == 3) return AppColor.bronzeMedal;
    return Colors.transparent;
  }

  Color get _borderColor {
    if (rank == 1) return AppColor.goldMedalBorder;
    if (rank == 2) return AppColor.silverMedalBorder;
    if (rank == 3) return AppColor.bronzeMedalBorder;
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 19,
          height: 19,
          decoration: BoxDecoration(
            color: _fillColor,
            shape: BoxShape.circle,
            border: Border.all(width: 1.5, color: _borderColor),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 1.5),
          child: Text(
            '$rank',
            style: AppTextStyle.rankingNumber,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

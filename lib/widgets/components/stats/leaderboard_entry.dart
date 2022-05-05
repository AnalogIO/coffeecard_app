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
    if (rank == 1) return const Color(0xffFFD91D);
    if (rank == 2) return const Color(0xffC2C2C2);
    if (rank == 3) return const Color(0xffD9A169);
    return Colors.transparent;
  }

  Color get _borderColor {
    if (rank == 1) return const Color(0xffB3980E);
    if (rank == 2) return const Color(0xff767676);
    if (rank == 3) return const Color(0xff7A4C1F);
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 20,
          height: 20,
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

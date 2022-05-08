import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/helpers/shimmer_builder.dart';
import 'package:coffeecard/widgets/components/list_entry.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LeaderboardEntry extends StatelessWidget {
  final String name;
  final int score;
  final int rank;
  final bool highlight;
  final bool isPlaceholder;

  const LeaderboardEntry({
    required this.name,
    required this.score,
    required this.rank,
    required this.highlight,
  }) : isPlaceholder = false;

  const LeaderboardEntry.placeholder()
      : name = 'placeholder',
        score = 0,
        rank = 10,
        highlight = false,
        isPlaceholder = true;

  String get _scoreText =>
      '$score ${score != 1 ? Strings.statCups : Strings.statCup}';

  @override
  Widget build(BuildContext context) {
    return ListEntry(
      backgroundColor: highlight ? AppColor.slightlyHighlighted : null,
      leftWidget: ShimmerBuilder(
        showShimmer: isPlaceholder,
        builder: (context, colorIfShimmer) {
          return Row(
            children: [
              Container(
                color: colorIfShimmer,
                child: _LeaderboardRankMedal(rank),
              ),
              const Gap(16),
              Container(
                color: colorIfShimmer,
                child: const CircleAvatar(),
              ),
              const Gap(10),
              Flexible(
                child: Container(
                  color: colorIfShimmer,
                  child: Text(
                    name,
                    style: AppTextStyle.textField,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      rightWidget: ShimmerBuilder(
        showShimmer: isPlaceholder,
        builder: (context, colorIfShimmer) {
          return Container(
            color: colorIfShimmer,
            child: Text(_scoreText),
          );
        },
      ),
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

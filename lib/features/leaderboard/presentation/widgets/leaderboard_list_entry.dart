import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/app_colors.dart';
import 'package:coffeecard/base/style/app_text_styles.dart';
import 'package:coffeecard/core/widgets/list_entry.dart';
import 'package:coffeecard/features/settings/presentation/widgets/user_icon.dart';
import 'package:coffeecard/widgets/components/helpers/shimmer_builder.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LeaderboardListEntry extends StatelessWidget {
  final int id;
  final String name;
  final int score;
  final int rank;
  final bool highlight;
  final bool isPlaceholder;

  const LeaderboardListEntry({
    required this.id,
    required this.name,
    required this.score,
    required this.rank,
    required this.highlight,
  }) : isPlaceholder = false;

  const LeaderboardListEntry.placeholder()
      : id = 0,
        name = 'placeholder',
        score = 0,
        rank = 10,
        highlight = false,
        isPlaceholder = true;

  String get _scoreText =>
      '$score ${score != 1 ? Strings.statCups : Strings.statCup}';

  @override
  Widget build(BuildContext context) {
    return ListEntry(
      backgroundColor: highlight ? AppColors.slightlyHighlighted : null,
      sideToExpand: ListEntrySide.right,
      leftWidget: ShimmerBuilder(
        showShimmer: isPlaceholder,
        builder: (context, colorIfShimmer) {
          return Row(
            children: [
              ColoredBox(
                color: colorIfShimmer,
                child: _LeaderboardRankMedal(rank),
              ),
              const Gap(16),
              UserIcon.small(id: id),
              const Gap(10),
              Flexible(
                child: ColoredBox(
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
          return ColoredBox(
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

  String get rankString => rank == 0 ? '-' : '$rank';

  Color get _fillColor {
    if (rank == 1) return AppColors.goldMedal;
    if (rank == 2) return AppColors.silverMedal;
    if (rank == 3) return AppColors.bronzeMedal;
    return Colors.transparent;
  }

  Color get _borderColor {
    if (rank == 1) return AppColors.goldMedalBorder;
    if (rank == 2) return AppColors.silverMedalBorder;
    if (rank == 3) return AppColors.bronzeMedalBorder;
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
            rankString,
            style: AppTextStyle.rankingNumber,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

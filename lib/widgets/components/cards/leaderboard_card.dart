import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/cards/card.dart';
import 'package:coffeecard/widgets/components/left_aligned_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LeaderboardCard extends CardBase {
  final int rank;
  final String name;
  final String programme;
  final int cups;

  LeaderboardCard({
    required this.rank,
    required this.name,
    required this.programme,
    required this.cups,
  }) : super(
          dense: true,
          borderRadius: 0,
          color: AppColor.white,
          top: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(formatRank(rank)),
                    const Gap(10),
                    const CircleAvatar(),
                    const Gap(10),
                    LeftAlignedText(
                      name,
                      style: AppTextStyle.textField,
                    ),
                    /*
                    //FIXME: programme not available yet, uncomment once it is
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LeftAlignedText(
                          name,
                          style: AppTextStyle.textField,
                        ),
                        LeftAlignedText(
                          programme,
                          style: AppTextStyle.label,
                        ),
                      ],
                    ),
                    */
                  ],
                ),
                Text('$cups cups'),
              ],
            ),
          ),
        );
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

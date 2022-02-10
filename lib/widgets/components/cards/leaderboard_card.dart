import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/widgets/components/cards/card.dart';
import 'package:coffeecard/widgets/components/left_aligned_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LeaderboardCard extends CardBase {
  //FIXME: implement in a smarter way once user data is available
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
                    Text('$rank'),
                    const Gap(10),
                    const CircleAvatar(),
                    const Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LeftAlignedText(name),
                        LeftAlignedText(programme),
                      ],
                    ),
                  ],
                ),
                Text('$cups cups'),
              ],
            ),
          ),
        );
}

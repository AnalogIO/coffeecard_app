import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/models/contributor.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ContributorCard extends StatelessWidget {
  final Contributor contributor;

  const ContributorCard(this.contributor);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        color: AppColor.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(contributor.avatarUrl),
                radius: 24,
              ),
              const Gap(4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contributor.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.recieptItemKey,
                  ),
                  const Gap(3),
                  Text(
                    contributor.githubUrl,
                    style: AppTextStyle.explainer,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

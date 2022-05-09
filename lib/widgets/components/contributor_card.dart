import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/models/contributor.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ContributorCard extends StatelessWidget {
  final Contributor contributor;

  const ContributorCard(this.contributor);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Column(
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
            ),
            const Gap(16),
            CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(contributor.avatarUrl),
              radius: 36,
            ),
          ],
        ),
      ),
    );
  }
}

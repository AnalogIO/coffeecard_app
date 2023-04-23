import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/features/contributor/domain/entities/contributor.dart';
import 'package:coffeecard/utils/launch.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ContributorCard extends StatelessWidget {
  final Contributor contributor;

  const ContributorCard(this.contributor);

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: () => launchUrlExternalApplication(
        Uri.parse(contributor.githubUrl),
        context,
      ),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColor.white,
          border: Border(bottom: BorderSide(color: AppColor.lightGray)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: contributor.avatarUrl,
                placeholder: (context, url) => const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    color: AppColor.primary,
                    strokeWidth: 2,
                  ),
                ),
                imageBuilder: (context, imageProvider) => Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const Gap(8),
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
                    contributor.githubUrl.replaceAll('https://', ''),
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

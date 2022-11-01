import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/widgets/components/helpers/shimmer_builder.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
import 'package:coffeecard/widgets/components/user_icon.dart';
import 'package:coffeecard/widgets/pages/settings/your_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    required this.name,
    required this.occupation,
    required this.id,
  }) : isPlaceholder = false;

  const UserCard.placeholder()
      : id = 0,
        isPlaceholder = true,
        name = 'Loading',
        occupation = 'Occupation name fullname';

  final int id;
  final String name;
  final String occupation;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Tappable(
        onTap: isPlaceholder
            ? null
            : () => Navigator.push(context, YourProfilePage.route),
        borderRadius: BorderRadius.circular(24.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: ShimmerBuilder(
            showShimmer: isPlaceholder,
            builder: (context, colorIfShimmer) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GravatarImage.small(id: id),
                  const Gap(8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ColoredBox(
                          color: colorIfShimmer,
                          child: Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.recieptItemKey,
                          ),
                        ),
                        const Gap(3),
                        ColoredBox(
                          color: colorIfShimmer,
                          child: Text(
                            occupation,
                            style: AppTextStyle.explainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(16),
                  const Icon(Icons.edit, color: AppColor.primary),
                  const Gap(12),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

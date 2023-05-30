import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/features/settings/presentation/pages/your_profile_page.dart';
import 'package:coffeecard/features/settings/presentation/widgets/user_icon.dart';
import 'package:coffeecard/widgets/components/helpers/shimmer_builder.dart';
import 'package:coffeecard/widgets/components/helpers/tappable.dart';
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
        name = Strings.loading,
        occupation = Strings.occupationPlaceholder;

  final int id;
  final String name;
  final String occupation;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24.0)),
      ),
      child: Tappable(
        onTap: isPlaceholder
            ? null
            : () => Navigator.push(context, YourProfilePage.route),
        borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          child: ShimmerBuilder(
            showShimmer: isPlaceholder,
            builder: (context, colorIfShimmer) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UserIcon.small(id: id),
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
                            style: AppTextStyle.receiptItemKey,
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

import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/helpers/grid.dart';
import 'package:coffeecard/core/widgets/components/section_title.dart';
import 'package:coffeecard/core/widgets/components/user_role_indicator.dart';
import 'package:coffeecard/features/product/domain/entities/product.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/perk_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BaristaPerksSection extends StatelessWidget {
  const BaristaPerksSection(this.userRole, this.perks);

  final String userRole;
  final Iterable<Product> perks;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle.withSideWidget(
          Strings.perksTitle(userRole),
          sideWidget: UserRoleIndicator(userRole),
        ),
        Grid(
          gap: GridGap.normal,
          gapSmall: GridGap.tight,
          singleColumnOnSmallDevice: true,
          children: perks.map(PerkCard.fromProduct).toList(),
        ),
        const Gap(16),
      ],
    );
  }
}

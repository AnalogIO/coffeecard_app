import 'package:coffeecard/core/extensions/string_extensions.dart';
import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/helpers/grid.dart';
import 'package:coffeecard/core/widgets/components/section_title.dart';
import 'package:coffeecard/core/widgets/components/user_role_indicator.dart';
import 'package:coffeecard/features/product/domain/entities/purchasable_products.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/perk_card.dart';
import 'package:coffeecard/features/user/domain/entities/role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class BaristaPerksSection extends StatefulWidget {
  const BaristaPerksSection({required this.userRole});

  final Role userRole;

  @override
  State<BaristaPerksSection> createState() => _BaristaPerksSectionState();
}

class _BaristaPerksSectionState extends State<BaristaPerksSection> {
  @override
  Widget build(BuildContext context) {
    final perks = context.watch<PurchasableProducts>().perks;
    final roleName = widget.userRole.name.capitalize();
    return Column(
      children: [
        SectionTitle.withSideWidget(
          Strings.perksTitle(roleName),
          sideWidget: UserRoleIndicator(widget.userRole),
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

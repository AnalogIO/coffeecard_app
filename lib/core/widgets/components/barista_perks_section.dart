import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/barista_indicator.dart';
import 'package:coffeecard/core/widgets/components/error_section.dart';
import 'package:coffeecard/core/widgets/components/helpers/grid.dart';
import 'package:coffeecard/core/widgets/components/section_title.dart';
import 'package:coffeecard/features/product/domain/entities/purchasable_products.dart';
import 'package:coffeecard/features/product/presentation/cubit/product_cubit.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/shop_card.dart';
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SectionTitle(Strings.baristaPerks),
            BaristaIndicator(
              userRole: widget.userRole,
            ),
          ],
        ),
        Grid(
          gap: GridGap.normal,
          gapSmall: GridGap.tight,
          singleColumnOnSmallDevice: true,
          children: perks.map(ShopCard.fromProduct).toList(),
        ),
        const Gap(16),
      ],
    );
  }
}

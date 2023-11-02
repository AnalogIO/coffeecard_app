import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/barista_indicator.dart';
import 'package:coffeecard/core/widgets/components/error_section.dart';
import 'package:coffeecard/core/widgets/components/helpers/grid.dart';
import 'package:coffeecard/core/widgets/components/loading.dart';
import 'package:coffeecard/core/widgets/components/section_title.dart';
import 'package:coffeecard/features/product/presentation/cubit/product_cubit.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/shop_card.dart';
import 'package:coffeecard/features/user/domain/entities/role.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BaristaPerksSection extends StatefulWidget {
  const BaristaPerksSection({required this.userRole});

  final Role userRole;

  @override
  State<BaristaPerksSection> createState() => _BaristaPerksSectionState();
}

class _BaristaPerksSectionState extends State<BaristaPerksSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SectionTitle(Strings.baristaPerks),
            BaristaIndicator(
              userRole: widget.userRole,
            ),
          ],
        ),
        BlocProvider(
          create: (context) => sl<ProductCubit>()..getProducts(),
          child: BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state is ProductsLoading) {
                return const Loading(loading: true);
              } else if (state is ProductsLoaded) {
                return Grid(
                  gap: GridGap.normal,
                  gapSmall: GridGap.tight,
                  singleColumnOnSmallDevice: true,
                  children: state.perks.map(ShopCard.fromProduct).toList(),
                );
              } else if (state is ProductsError) {
                return ErrorSection(
                  error: state.error,
                  retry: context.read<ProductCubit>().getProducts,
                );
              }

              throw ArgumentError(this);
            },
          ),
        ),
      ],
    );
  }
}

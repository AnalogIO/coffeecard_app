import 'dart:developer';

import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/core/widgets/upgrade_alert.dart';
import 'package:coffeecard/features/opening_hours/opening_hours.dart';
import 'package:coffeecard/features/ticket/presentation/cubit/tickets_cubit.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/shop_section.dart';
import 'package:coffeecard/features/ticket/presentation/widgets/tickets_section.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({required this.scrollController});

  final ScrollController scrollController;

  static Route routeWith({required ScrollController scrollController}) {
    return MaterialPageRoute(
      builder: (_) => TicketsPage(scrollController: scrollController),
    );
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: AppScaffold.withTitle(
        title: Strings.ticketsPageTitle,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                controller: scrollController,
                shrinkWrap: true,
                padding: const EdgeInsets.all(16.0),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionTitle(Strings.ticketsMyTickets),
                      if ((context.read<UserCubit>().state as UserLoaded)
                          .user
                          .hasBaristaPerks)
                        const SwitchWidget(),
                    ],
                  ),
                  const TicketSection(),
                  const Gap(24),
                  const SectionTitle(Strings.shopText),
                  const ShopSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SwitchWidget extends StatefulWidget {
  const SwitchWidget({super.key});

  @override
  State<SwitchWidget> createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  // bool toggleState = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: context.read<TicketsCubit>().state.isBarista,
      onChanged: (val) {
        log('$val');
        setState(() {
          // toggleState = val;
          context.read<TicketsCubit>().setBaristaMode(baristaMode: val);
        });
      },
    );
  }
}

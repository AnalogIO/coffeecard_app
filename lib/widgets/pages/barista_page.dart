import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/core/widgets/upgrade_alert.dart';
import 'package:coffeecard/features/opening_hours/opening_hours.dart';
import 'package:coffeecard/widgets/components/forms/barista/barista_perks_section.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/section_title.dart';
import 'package:coffeecard/widgets/components/tickets/tickets_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BaristaPage extends StatelessWidget {
  const BaristaPage({required this.scrollController});

  final ScrollController scrollController;

  static Route routeWith({required ScrollController scrollController}) {
    return MaterialPageRoute(
      builder: (_) => BaristaPage(scrollController: scrollController),
    );
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: AppScaffold.withTitle(
        title: Strings.baristaPageTitle,
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
                    children: const [
                      SectionTitle(Strings.baristaTickets),
                      OpeningHoursIndicator(),
                    ],
                  ),
                  const BaristaTicketSection(),
                  const Gap(24),
                  const SectionTitle(Strings.baristaPerks),
                  const BaristaPerksSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

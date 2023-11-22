import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/core/widgets/components/scaffold.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/timeslot.dart';
import 'package:coffeecard/features/opening_hours/presentation/cubit/opening_hours_cubit.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class OpeningHoursPage extends StatelessWidget {
  const OpeningHoursPage({required this.state});

  final OpeningHoursLoaded state;

  static Route routeWith({required OpeningHoursLoaded state}) {
    return MaterialPageRoute(builder: (_) => OpeningHoursPage(state: state));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.openingHours,
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _OpeningHoursView(openingHours: state.week),
                const Gap(36),
                Row(
                  children: [
                    const Spacer(),
                    Flexible(
                      flex: 3,
                      child: Text(
                        Strings.openingHoursDisclaimer,
                        style: AppTextStyle.explainerDark,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OpeningHoursView extends StatelessWidget {
  const _OpeningHoursView({required this.openingHours});

  final Map<int, Timeslot> openingHours;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: Strings.weekdaysPlural.length,
      separatorBuilder: (_, __) => const Gap(12),
      itemBuilder: (_, index) {
        final weekday = index + 1;
        final hours = switch (openingHours[weekday]) {
          final Timeslot timeslot => timeslot.format(context),
          _ => Strings.closed,
        };

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              Strings.weekdaysPlural[weekday]!,
              style: AppTextStyle.settingKey,
            ),
            Text(
              hours,
              style: AppTextStyle.receiptItemKey,
            ),
          ],
        );
      },
    );
  }
}

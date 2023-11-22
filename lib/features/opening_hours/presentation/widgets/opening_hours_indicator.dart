import 'dart:async';

import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/timeslot.dart';
import 'package:coffeecard/features/opening_hours/presentation/cubit/opening_hours_cubit.dart';
import 'package:coffeecard/features/opening_hours/presentation/widgets/analog_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart' show Option, Some;
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class OpeningHoursIndicator extends StatefulWidget {
  const OpeningHoursIndicator();

  @override
  State<OpeningHoursIndicator> createState() => _OpeningHoursIndicatorState();
}

class _OpeningHoursIndicatorState extends State<OpeningHoursIndicator> {
  late Timer timer;
  final refreshDuration = const Duration(minutes: 1);

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(refreshDuration, (_) => setState(() {}));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String get currentWeekday => DateFormat.E().format(DateTime.now());

  (Color, String) openColorAndText(Timeslot timeslot) => (
        AppColors.success,
        '$currentWeekday: ${timeslot.format(context)}',
      );
  (Color, String) get closedColorAndText => (
        AppColors.errorOnBright,
        '${Strings.openingHoursIndicatorPrefix} ${Strings.closed}',
      );

  (Color, String) colorAndText(Option<Timeslot> todaysOpeningHours) {
    final isOpen = TimeOfDay.now().isInTimeslot;
    return switch (todaysOpeningHours) {
      Some(value: final hours) when isOpen(hours) => openColorAndText(hours),
      _ => closedColorAndText,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpeningHoursCubit, OpeningHoursState>(
      builder: (_, state) {
        return switch (state) {
          OpeningHoursLoaded(:final today) => _Content(colorAndText(today)),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class _Content extends StatelessWidget {
  _Content((Color, String) colorAndText)
      : color = colorAndText.$1,
        text = colorAndText.$2;

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: AppTextStyle.openingHoursIndicator.copyWith(color: color),
      child: Theme(
        data: Theme.of(context)
            .copyWith(iconTheme: IconThemeData(color: color, size: 18)),
        child: Row(
          children: [
            const Icon(AnalogIcons.closed),
            const Gap(8),
            Text(text),
          ],
        ),
      ),
    );
  }
}

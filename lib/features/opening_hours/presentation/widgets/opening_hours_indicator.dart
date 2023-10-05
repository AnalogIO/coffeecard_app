import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/styles/app_text_styles.dart';
import 'package:coffeecard/features/opening_hours/presentation/cubit/opening_hours_cubit.dart';
import 'package:coffeecard/features/opening_hours/presentation/widgets/analog_icons.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class OpeningHoursIndicator extends StatelessWidget {
  const OpeningHoursIndicator();

  String get formatCurrentWeekday => DateFormat('EEEE')
      .format(DateTime.now())
      .characters
      .getRange(0, 3)
      .toString();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpeningHoursCubit, OpeningHoursState>(
      builder: (context, state) {
        if (state is! OpeningHoursLoaded) {
          return const SizedBox.shrink();
        }

        final text = state.isOpen
            ? '$formatCurrentWeekday: ${state.todaysOpeningHours}'
            : '${Strings.openingHoursIndicatorPrefix} ${Strings.closed}';
        final color =
            state.isOpen ? AppColors.success : AppColors.errorOnBright;

        final textStyle =
            AppTextStyle.openingHoursIndicator.copyWith(color: color);

        return Row(
          children: [
            Icon(AnalogIcons.closed, size: 18, color: color),
            const Gap(8),
            Text(
              text,
              style: textStyle,
            ),
          ],
        );
      },
    );
  }
}

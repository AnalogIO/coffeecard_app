import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/features/opening_hours/presentation/cubit/opening_hours_cubit.dart';
import 'package:coffeecard/utils/analog_icons.dart';
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
        if (state is OpeningHoursError) {
          return const SizedBox.shrink();
        }

        var isOpen = false;
        if (state is OpeningHoursLoaded) {
          isOpen = state.isOpen;
        }

        final todaysOpeningHours =
            (state as OpeningHoursLoaded).openingHours[DateTime.now().weekday]!;

        final text = isOpen
            ? '$formatCurrentWeekday $todaysOpeningHours'
            : '${Strings.openingHoursIndicatorPrefix} ${Strings.closed}';
        final color = isOpen ? AppColor.success : AppColor.errorOnBright;
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

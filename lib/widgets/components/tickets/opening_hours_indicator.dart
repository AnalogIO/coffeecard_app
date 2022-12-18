import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/base/style/text_styles.dart';
import 'package:coffeecard/cubits/opening_hours/opening_hours_cubit.dart';
import 'package:coffeecard/utils/analog_icons.dart';
import 'package:coffeecard/widgets/components/helpers/shimmer_builder.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class OpeningHoursIndicator extends StatelessWidget {
  const OpeningHoursIndicator();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpeningHoursCubit, OpeningHoursState>(
      builder: (context, state) {
        var isOpen = false;
        if (state is OpeningHoursLoaded) {
          isOpen = state.isOpen;
        }
        final openOrClosed = isOpen ? Strings.open : Strings.closed;
        final color = isOpen ? AppColor.success : AppColor.errorOnBright;
        final textStyle =
            AppTextStyle.openingHoursIndicator.copyWith(color: color);

        return ShimmerBuilder(
          showShimmer: state is OpeningHoursLoading,
          builder: (context, colorIfShimmer) {
            return Row(
              children: [
                Icon(AnalogIcons.closed, size: 18, color: color),
                const Gap(8),
                ColoredBox(
                  color: colorIfShimmer,
                  child: Text(
                    '${Strings.openingHoursIndicatorPrefix} $openOrClosed',
                    style: textStyle,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/opening_hours/opening_hours.dart';
import 'package:equatable/equatable.dart';

part 'opening_hours_state.dart';

class OpeningHoursCubit extends Cubit<OpeningHoursState> {
  final GetOpeningHours fetchOpeningHours;
  final CheckOpenStatus isOpen;

  OpeningHoursCubit({required this.fetchOpeningHours, required this.isOpen})
      : super(const OpeningHoursLoading());

  Future<void> getOpeninghours() async {
    emit(const OpeningHoursLoading());

    final either = await isOpen(NoParams());

    either.fold(
      (error) => emit(OpeningHoursError(error: error.reason)),
      (isOpen) async {
        final openingHoursResult = await fetchOpeningHours(NoParams());

        openingHoursResult.fold(
          (error) => emit(OpeningHoursError(error: error.reason)),
          (openingHours) => emit(
            OpeningHoursLoaded(
              isOpen: isOpen,
              openingHours: openingHours,
            ),
          ),
        );
      },
    );
  }

  /// Return the current weekday and the corresponding opening hours e.g
  /// 'Monday: 8 - 16'
  String weekdayAndOpeningHours() {
    if (state is OpeningHoursLoading) {
      return Strings.openingHoursShimmerText;
    }

    final today = DateTime.now().weekday;
    final weekdayPlural = Strings.weekdaysPlural[today]!;

    if (state is OpeningHoursLoaded) {
      final st = state as OpeningHoursLoaded;

      final hours = st.openingHours[today];
      return '$weekdayPlural: $hours';
    }

    return '';
  }
}

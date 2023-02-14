import 'package:bloc/bloc.dart';
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
              openingHours: openingHours.allOpeningHours,
              todaysOpeningHours: openingHours.todaysOpeningHours,
            ),
          ),
        );
      },
    );
  }
}

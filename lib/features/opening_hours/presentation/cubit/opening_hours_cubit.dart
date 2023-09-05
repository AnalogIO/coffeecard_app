import 'package:bloc/bloc.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/opening_hours/domain/usecases/check_open_status.dart';
import 'package:coffeecard/features/opening_hours/domain/usecases/get_opening_hours.dart';
import 'package:equatable/equatable.dart';

part 'opening_hours_state.dart';

class OpeningHoursCubit extends Cubit<OpeningHoursState> {
  final GetOpeningHours fetchOpeningHours;
  final CheckOpenStatus checkIsOpen;

  OpeningHoursCubit({
    required this.fetchOpeningHours,
    required this.checkIsOpen,
  }) : super(const OpeningHoursLoading());

  Future<void> getOpeninghours() async {
    emit(const OpeningHoursLoading());

    final either = await checkIsOpen(NoParams());

    either.fold(
      (error) => emit(OpeningHoursError(error: error.reason)),
      (isOpen) async {
        final openingHoursResult = await fetchOpeningHours(NoParams());

        openingHoursResult.fold(
          (error) => emit(OpeningHoursError(error: error.reason)),
          (openingHours) {
            final todaysOpeningHours = openingHours[DateTime.now().weekday]!;

            emit(
              OpeningHoursLoaded(
                isOpen: isOpen,
                openingHours: openingHours
                    .map((key, value) => MapEntry(key, value.toString())),
                todaysOpeningHours: todaysOpeningHours.toString(),
              ),
            );
          },
        );
      },
    );
  }
}

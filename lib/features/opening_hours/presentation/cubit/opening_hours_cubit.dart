import 'package:bloc/bloc.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/opening_hours/domain/usecases/fetch_opening_hours.dart';
import 'package:coffeecard/features/opening_hours/domain/usecases/is_open.dart';
import 'package:equatable/equatable.dart';

part 'opening_hours_state.dart';

class OpeningHoursCubit extends Cubit<OpeningHoursState> {
  final FetchOpeningHours fetchOpeningHours;
  final GetIsOpen isOpen;

  OpeningHoursCubit({required this.fetchOpeningHours, required this.isOpen})
      : super(const OpeningHoursLoading());

  Future<void> getOpeninghours() async {
    emit(const OpeningHoursLoading());

    final either = await isOpen(NoParams());

    either.fold(
      (error) => emit(
        const OpeningHoursLoaded(
          status: OpeningHoursStatus.unknown,
          openingHours: {},
        ),
      ),
      (isOpen) async {
        final openingHoursStatus =
            isOpen ? OpeningHoursStatus.open : OpeningHoursStatus.closed;

        final openingHoursResult = await fetchOpeningHours(NoParams());

        openingHoursResult.fold(
          (error) => emit(
            OpeningHoursLoaded(
              status: openingHoursStatus,
              openingHours: const {},
            ),
          ),
          (openingHours) => emit(
            OpeningHoursLoaded(
              status: openingHoursStatus,
              openingHours: openingHours,
            ),
          ),
        );
      },
    );
  }
}

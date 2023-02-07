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
      : super(const Loading());

  Future<void> getOpeninghours() async {
    emit(const Loading());

    final isOpenResult = await isOpen(NoParams());

    if (isOpenResult.isLeft) {
      emit(Error(isOpenResult.left.reason));
      return;
    }

    final openingHoursResult = await fetchOpeningHours(NoParams());

    openingHoursResult.caseOf(
      (error) => emit(Error(openingHoursResult.left.reason)),
      (openingHours) => emit(
        Loaded(
          isOpen: isOpenResult.right,
          openingHours: openingHoursResult.right,
        ),
      ),
    );
  }
}

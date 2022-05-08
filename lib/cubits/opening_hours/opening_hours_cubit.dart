import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/shiftplanning/opening_hours_repository.dart';
import 'package:equatable/equatable.dart';

part 'opening_hours_state.dart';

class OpeningHoursCubit extends Cubit<OpeningHoursState> {
  OpeningHoursCubit(this._repo) : super(const OpeningHoursLoading());
  final OpeningHoursRepository _repo;

  Future<void> getOpeninghours() async {
    emit(const OpeningHoursLoading());
    final isOpenResult = await _repo.isOpen();
    final openingHoursResult = await _repo.getOpeningHours();

    if (isOpenResult.isLeft) {
      emit(OpeningHoursError(isOpenResult.left.message));
    } else if (openingHoursResult.isLeft) {
      emit(OpeningHoursError(openingHoursResult.left.message));
    } else {
      emit(
        OpeningHoursLoaded(
          isOpen: isOpenResult.right,
          openingHours: openingHoursResult.right,
        ),
      );
    }
  }
}

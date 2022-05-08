import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/shiftplanning/opening_hours_repository.dart';
import 'package:equatable/equatable.dart';

part 'opening_hours_state.dart';

class OpeningHoursCubit extends Cubit<OpeningHoursState> {
  OpeningHoursCubit(this._repo) : super(const OpeningHoursLoading());
  final OpeningHoursRepository _repo;

  Future<void> getOpeninghours() async {
    emit(const OpeningHoursLoading());
    final either = await _repo.isOpen();

    if (either.isRight) {
      emit(OpeningHoursLoaded(isOpen: either.right));
    } else {
      emit(OpeningHoursError(either.left.errorMessage));
    }
  }
}

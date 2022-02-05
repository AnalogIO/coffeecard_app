import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/shiftplanning/opening_hours_repository.dart';
import 'package:coffeecard/service_locator.dart';

part 'analog_closed_popup_state.dart';

class AnalogClosedPopupCubit extends Cubit<AnalogClosedPopupState> {
  final OpeningHoursRepository _hoursRepository =
      sl.get<OpeningHoursRepository>();

  AnalogClosedPopupCubit() : super(const AnalogClosedPopupLoading());

  Future<void> getOpeninghours() async {
    emit(const AnalogClosedPopupLoading());

    final either = await _hoursRepository.isOpen();

    if (either.success) {
      final isOpen = either.right;
      if (isOpen) {
        emit(const AnalogClosedPopupHidden());
      } else {
        emit(const AnalogClosedPopupVisible());
      }
    } else {
      emit(AnalogClosedPopupError(either.left.errorMessage));
    }
  }

  void closePopup() {
    emit(const AnalogClosedPopupHidden());
  }
}

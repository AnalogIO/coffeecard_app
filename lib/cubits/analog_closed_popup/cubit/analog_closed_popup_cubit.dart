import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/shiftplanning/opening_hours_repository.dart';
import 'package:coffeecard/errors/network_exception.dart';
import 'package:coffeecard/service_locator.dart';

part 'analog_closed_popup_state.dart';

class AnalogClosedPopupCubit extends Cubit<AnalogClosedPopupState> {
  final OpeningHoursRepository _hoursRepository =
      sl.get<OpeningHoursRepository>();

  AnalogClosedPopupCubit() : super(const AnalogClosedPopupLoading());

  Future<void> getOpeninghours() async {
    try {
      emit(const AnalogClosedPopupLoading());

      final isOpen = await _hoursRepository.isOpen();

      if (isOpen) {
        emit(const AnalogClosedPopupHidden());
      } else {
        emit(const AnalogClosedPopupVisible());
      }
    } on NetworkException catch (e) {
      emit(AnalogClosedPopupError(e.message));
    }
  }

  void closePopup() {
    emit(const AnalogClosedPopupHidden());
  }
}

import 'package:bloc/bloc.dart';
import 'package:coffeecard/errors/network_exception.dart';

part 'analog_closed_popup_state.dart';

class AnalogClosedPopupCubit extends Cubit<AnalogClosedPopupState> {
  AnalogClosedPopupCubit() : super(const AnalogClosedPopupLoading());

  Future<void> getOpeninghours() async {
    try {
      emit(const AnalogClosedPopupLoading());
      await Future.delayed(const Duration(seconds: 1));

      //FIXME: fetch when data is available
      const isClosed = true;

      if (isClosed) {
        emit(const AnalogClosedPopupVisible());
      } else {
        emit(const AnalogClosedPopupHidden());
      }
    } on NetworkException catch (e) {
      emit(AnalogClosedPopupError(e.message));
    }
  }

  void closePopup() {
    emit(const AnalogClosedPopupHidden());
  }
}

part of 'analog_closed_popup_cubit.dart';

abstract class AnalogClosedPopupState {
  const AnalogClosedPopupState();
}

class AnalogClosedPopupHidden extends AnalogClosedPopupState {
  const AnalogClosedPopupHidden();
}

class AnalogClosedPopupVisible extends AnalogClosedPopupState {
  const AnalogClosedPopupVisible();
}

class AnalogClosedPopupLoading extends AnalogClosedPopupState {
  const AnalogClosedPopupLoading();
}

class AnalogClosedPopupError extends AnalogClosedPopupState {
  final String message;

  const AnalogClosedPopupError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AnalogClosedPopupError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

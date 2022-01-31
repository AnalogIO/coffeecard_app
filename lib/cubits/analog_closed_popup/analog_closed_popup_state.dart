part of 'analog_closed_popup_cubit.dart';

abstract class AnalogClosedPopupState extends Equatable {
  const AnalogClosedPopupState();
}

class AnalogClosedPopupHidden extends AnalogClosedPopupState {
  const AnalogClosedPopupHidden();

  @override
  List<Object?> get props => [];
}

class AnalogClosedPopupVisible extends AnalogClosedPopupState {
  const AnalogClosedPopupVisible();

  @override
  List<Object?> get props => [];
}

class AnalogClosedPopupLoading extends AnalogClosedPopupState {
  const AnalogClosedPopupLoading();

  @override
  List<Object?> get props => [];
}

class AnalogClosedPopupError extends AnalogClosedPopupState {
  final String message;

  const AnalogClosedPopupError(this.message);

  @override
  List<Object?> get props => [message];
}

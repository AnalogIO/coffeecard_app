part of 'form_bloc.dart';

sealed class FormEvent extends Equatable {
  const FormEvent();
}

/// The form wants to validate itself and should show a loading indicator.
class FormValidateRequested extends FormEvent {
  const FormValidateRequested();

  @override
  List<Object?> get props => [];
}

/// The form should begin validation.
///
/// This event is separated from [FormValidateRequested]
/// as this event can be debounced.
class FormValidateStarted extends FormEvent {
  const FormValidateStarted({required this.input});
  final String input;

  @override
  List<Object?> get props => [input];
}

/// The form should either enable/disable displaying
/// the error message (if there is an error).
class FormToggleErrorDisplay extends FormEvent {
  const FormToggleErrorDisplay({required this.showError});
  final bool showError;

  @override
  List<Object?> get props => [showError];
}

part of 'form_bloc.dart';

sealed class FormEvent extends Equatable {}

/// The form wants to validate itself and should show a loading indicator.
class FormValidateRequested extends FormEvent {
  @override
  List<Object?> get props => [];
}

/// The form should begin validation.
///
/// This event is separated from [FormValidateRequested]
/// as this event can be debounced.
class FormValidateStarted extends FormEvent {
  FormValidateStarted({required this.input});
  final String input;

  @override
  List<Object?> get props => [input];
}

/// The form should either enable/disable displaying
/// the error message (if there is an error).
class FormToggleErrorDisplay extends FormEvent {
  FormToggleErrorDisplay({required this.displayError});
  final bool displayError;

  @override
  List<Object?> get props => [displayError];
}

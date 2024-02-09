part of 'form_bloc.dart';

class FormState extends Equatable {
  const FormState({
    this.loading = false,
    this.text = '',
    this.canSubmit = false,
    this.shouldDisplayError = false,
    this.validationStatus = const Right(unit),
  });

  final bool loading;
  final String text;
  final bool canSubmit;
  final bool shouldDisplayError;
  final Either<String, Unit> validationStatus;

  @override
  List<Object?> get props => [
        loading,
        text,
        canSubmit,
        shouldDisplayError,
        validationStatus,
      ];

  FormState copyWith({
    bool? loading,
    String? text,
    bool? canSubmit,
    bool? shouldDisplayError,
    Either<String, Unit>? validationStatus,
  }) {
    return FormState(
      loading: loading ?? this.loading,
      text: text ?? this.text,
      canSubmit: canSubmit ?? this.canSubmit,
      shouldDisplayError: shouldDisplayError ?? this.shouldDisplayError,
      validationStatus: validationStatus ?? this.validationStatus,
    );
  }
}

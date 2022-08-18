part of 'form_bloc.dart';

class FormState extends Equatable {
  const FormState({
    this.loading = false,
    this.text = '',
    this.canSubmit = false,
    this.shouldDisplayError = false,
    this.error = const Right(null),
  });

  final bool loading;
  final String text;
  final bool canSubmit;
  final bool shouldDisplayError;
  final ErrorEither error;

  @override
  List<Object?> get props => [
        loading,
        text,
        canSubmit,
        shouldDisplayError,
        error,
      ];

  FormState copyWith({
    bool? loading,
    String? text,
    bool? canSubmit,
    bool? shouldDisplayError,
    ErrorEither? error,
  }) {
    return FormState(
      loading: loading ?? this.loading,
      text: text ?? this.text,
      canSubmit: canSubmit ?? this.canSubmit,
      shouldDisplayError: shouldDisplayError ?? this.shouldDisplayError,
      error: error ?? this.error,
    );
  }
}

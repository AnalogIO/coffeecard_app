part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final String? emailError;
  final bool loading;

  const RegisterState({
    this.emailError,
    this.loading = false,
  });

  RegisterState copyWith({String? emailError, bool? loading}) {
    return RegisterState(
      emailError: emailError,
      loading: loading ?? false,
    );
  }

  @override
  List<Object> get props => [loading, emailError ?? false];
}

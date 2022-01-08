part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final String? email;
  final String? passcode;
  final String? name;

  final bool loading;
  final String? error;
  bool get hasError => error != null;

  const RegisterState({
    this.email,
    this.passcode,
    this.name,
    this.loading = false,
    this.error,
  });

  RegisterState copyWith({
    String? email,
    String? passcode,
    String? name,
    bool? loading,
    String? error,
  }) {
    return RegisterState(
      email: email ?? this.email,
      passcode: passcode ?? this.passcode,
      name: name ?? this.name,
      loading: loading ?? false,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        email ?? false,
        passcode ?? false,
        name ?? false,
        loading,
        error,
      ];
}

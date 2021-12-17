part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final String? email;
  final String? passcode;
  final String? name;

  final bool loading;

  const RegisterState({
    this.email,
    this.passcode,
    this.name,
    this.loading = false,
  });

  RegisterState copyWith({
    String? email,
    String? passcode,
    String? name,
    bool? loading,
  }) {
    return RegisterState(
      email: email ?? this.email,
      passcode: passcode ?? this.passcode,
      name: name ?? this.name,
      loading: loading ?? false,
    );
  }

  @override
  List<Object> get props => [
        email ?? false,
        passcode ?? false,
        name ?? false,
        loading,
      ];
}

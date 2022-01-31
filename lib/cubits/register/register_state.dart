part of 'register_cubit.dart';

class RegisterState extends Equatable {
  final String? email;
  final String? passcode;
  final String? name;

  const RegisterState({
    this.email,
    this.passcode,
    this.name,
  });

  RegisterState copyWith({
    String? email,
    String? passcode,
    String? name,
  }) {
    return RegisterState(
      email: email ?? this.email,
      passcode: passcode ?? this.passcode,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [email, passcode, name];
}

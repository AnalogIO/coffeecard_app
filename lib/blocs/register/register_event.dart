part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class AddEmail extends RegisterEvent {
  final String email;
  const AddEmail(this.email);

  @override
  List<Object> get props => [email];
}

// class AttemptRegister extends RegisterEvent {
//   final String name;
//   final String email;
//   final String passcode;
//   const AttemptRegister({
//     required this.name,
//     required this.email,
//     required this.passcode,
//   });
//   @override
//   List<Object> get props => [email, passcode];
// }

class ClearEmailError extends RegisterEvent {}

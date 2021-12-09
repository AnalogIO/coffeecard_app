part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class AttemptRegister extends RegisterEvent {
  final String email;
  final String passcode;
  const AttemptRegister({required this.email, required this.passcode});
  @override
  List<Object> get props => [email, passcode];
}
// class VerifyPasscode extends RegisterEvent {
//   final String? repeatPasscodeValue;
//   const VerifyPasscode({this.repeatPasscodeValue});
//   @override
//   List<Object> get props => [repeatPasscodeValue ?? false];
// }

// class VerifyEmail extends RegisterEvent {
//   final String email;
//   const VerifyEmail({required this.email});
//   @override
//   List<Object> get props => [email];
// }

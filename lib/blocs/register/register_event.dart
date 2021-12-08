part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class VerifyForm extends RegisterEvent {
  final String repeatPasscodeValue;
  const VerifyForm({required this.repeatPasscodeValue});
  @override
  List<Object> get props => [repeatPasscodeValue];
}

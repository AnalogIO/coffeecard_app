part of 'register_cubit.dart';

sealed class RegisterState {}

class RegisterInitial extends RegisterState {}

/// The user has created their account.
class RegisterSuccess extends RegisterState {}

/// An error occurred trying to create an account.
class RegisterError extends RegisterState {
  RegisterError(this.errorMessage);
  final String errorMessage;
}

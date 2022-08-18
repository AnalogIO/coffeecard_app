part of 'input_validator.dart';

/// Helper input validators
class InputValidators {
  static InputValidator nonEmptyString({required String errorMessage}) {
    return InputValidator.bool(
      validate: (text) => text.isNotEmpty,
      errorMessage: errorMessage,
    );
  }

  static InputValidator validEmail({required String errorMessage}) {
    return InputValidator.bool(
      validate: emailIsValid,
      errorMessage: errorMessage,
    );
  }
}

part of 'input_validator.dart';

/// Helper input validators
class InputValidators {
  /// Returns an [InputValidator] that fails if the input is empty.
  static InputValidator nonEmptyString({required String errorMessage}) {
    return InputValidator.bool(
      validate: (text) => text.isNotEmpty,
      errorMessage: errorMessage,
    );
  }

  /// Returns an [InputValidator] that fails if the input is not a valid email.
  static InputValidator validEmail({required String errorMessage}) {
    return InputValidator.bool(
      validate: RegExp(r'^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]{2,}').hasMatch,
      errorMessage: errorMessage,
    );
  }
}

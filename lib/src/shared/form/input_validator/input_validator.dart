import 'dart:async';

import 'package:fpdart/fpdart.dart';

part 'input_validator_helpers.dart';

/// A content validator for [FormBase] widgets.
///
/// Example:
/// ```dart
/// class ExampleForm extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return FormBase(
///       inputValidators: [
///         InputValidator.bool(
///           validate: (input) => input.length == 4,
///           errorMessage: 'Must be 4 characters',
///         ),
///       ],
///       // rest of arguments here
///     );
///   }
/// }
/// ```
class InputValidator {
  /// Builds an input validator from a [validate]
  /// function that returns `FutureOr<Either<String, void>>`.
  const InputValidator({
    required this.validate,
    this.forceErrorMessage = false,
  });

  /// Builds an input validator from a [validate]
  /// function that returns a boolean.
  ///
  /// This constructor is preferred when the
  /// validator can only fail in one way.
  InputValidator.bool({
    /// The input validator. If it fails, it will
    /// return a `Left` with the given [errorMessage].
    required FutureOr<bool> Function(String input) validate,

    /// The error message to return if [validate] returns false.
    required String errorMessage,

    /// If failing this input validator should show an error message,
    /// even if the user has not submitted the form yet.
    bool forceErrorMessage = false,
  }) : this(
          validate: (String input) async {
            final validInput = await validate(input);
            return validInput ? const Right(unit) : Left(errorMessage);
          },
          forceErrorMessage: forceErrorMessage,
        );

  /// The input validator. Either returns an
  /// error message (left) or success (right).
  final FutureOr<Either<String, Unit>> Function(String input) validate;

  /// If failing this input validator should show an error message,
  /// even if the user has not pressed submit yet.
  final bool forceErrorMessage;
}

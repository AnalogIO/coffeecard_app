import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/styles/app_colors.dart';
import 'package:coffeecard/core/widgets/components/section_title.dart';
import 'package:coffeecard/core/widgets/components/tickets/rounded_button.dart';
import 'package:coffeecard/features/form/presentation/cubit/form_bloc.dart';
import 'package:coffeecard/utils/input_validator.dart';
import 'package:flutter/material.dart' hide FormState;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'form_text_field.dart';

enum TextFieldType { text, email, passcode }

class FormBase extends StatelessWidget {
  const FormBase({
    required this.inputValidators,
    this.title,
    required this.label,
    this.hint,
    this.initialValue = '',
    this.type = TextFieldType.text,
    this.maxLength,
    this.debounce = false,
    this.showCheckMark = false,
    this.autoSubmitValidInput = false,
    required this.onSubmit,
  });

  /// Validates the input whenever it changes.
  ///
  /// If any [InputValidator] fails, then the validation
  /// fails and the form cannot be submitted.
  final List<InputValidator> inputValidators;

  /// Optional title to show above the text field.
  final String? title;

  /// Label to show inside the text field.
  final String label;

  /// Text to show below the text field.
  final String? hint;

  /// Text to show in the text field.
  final String initialValue;

  /// The input type of the text field.
  final TextFieldType type;

  /// Max length of input. If set, an indicator is shown below the text field.
  /// If null, no limit is set.
  final int? maxLength;

  /// Whether or not to debounce validation of the input on input change.
  /// Useful for the email forms that validate by sending a request, as it will
  /// limit the amount of requests sent while the user fills out the text field.
  final bool debounce;

  /// Whether or not to show a checkmark icon when form can be submitted.
  final bool showCheckMark;

  /// Whether to automatically submit the form as
  /// soon as the input has been validated successfully.
  ///
  /// Used for passcode forms.
  final bool autoSubmitValidInput;

  /// Called when the form is submitted.
  final void Function(String text) onSubmit;

  @override
  Widget build(BuildContext _) {
    return BlocProvider(
      create: (_) => FormBloc(validators: inputValidators, debounce: debounce)
        ..add(FormValidateStarted(input: initialValue)),
      child: BlocConsumer<FormBloc, FormState>(
        listenWhen: (_, current) => autoSubmitValidInput && current.canSubmit,
        listener: (_, state) => onSubmit(state.text),
        builder: (context, state) {
          final bloc = context.read<FormBloc>();
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (title != null) SectionTitle.register(title!),
                  _FormTextField(
                    inputValidators: inputValidators,
                    onChanged: (input) {
                      if (!state.loading) {
                        bloc.add(FormValidateRequested());
                      }
                      bloc.add(FormValidateStarted(input: input));
                    },
                    onEditingComplete: () {
                      bloc.add(FormToggleErrorDisplay(displayError: true));
                      if (state.canSubmit) {
                        onSubmit(state.text);
                      }
                    },
                    label: label,
                    initialValue: initialValue,
                    hint: hint,
                    maxLength: maxLength,
                    loading: state.loading,
                    showCheckMark: state.canSubmit && showCheckMark,
                    type: type,
                  ),
                ],
              ),
              RoundedButton(
                text: Strings.buttonContinue,
                onTap: state.canSubmit ? () => onSubmit(state.text) : null,
              ),
            ],
          );
        },
      ),
    );
  }
}

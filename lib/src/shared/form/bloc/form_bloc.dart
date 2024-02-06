import 'package:bloc/bloc.dart';
import 'package:coffeecard/features/shared/form.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormState> {
  FormBloc({required this.validators, required this.debounce})
      : super(const FormState()) {
    on<FormValidateRequested>((event, emit) {
      emit(state.copyWith(loading: true, canSubmit: false));
    });

    on<FormValidateStarted>(
      (event, emit) async {
        final text = event.input.trim();
        for (final validator in validators) {
          final either = await validator.validate(text);

          if (either.isLeft()) {
            emit(
              state.copyWith(
                loading: false,
                canSubmit: false,
                validationStatus: either,
                shouldDisplayError: validator.forceErrorMessage ? true : null,
              ),
            );
            return;
          }
        }
        emit(
          state.copyWith(
            loading: false,
            text: text,
            canSubmit: true,
            validationStatus: const Right(unit),
          ),
        );
      },
      transformer: debounce ? debouncing() : null,
    );

    on<FormToggleErrorDisplay>((event, emit) {
      emit(state.copyWith(shouldDisplayError: event.displayError));
    });
  }

  final List<InputValidator> validators;
  final bool debounce;
}

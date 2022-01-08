import 'package:coffeecard/data/repositories/v1/account_repository.dart';
import 'package:coffeecard/model/account/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AccountRepository _accountRepository;

  SettingsBloc(this._accountRepository) : super(UserLoading()) {
    on<LoadUser>((event, emit) async {
      final user = await _accountRepository.getUser();
      emit(UserLoaded(user));
    });
  }
}

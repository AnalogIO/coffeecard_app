import 'package:coffeecard/data/repositories/v1/account_repository.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final AccountRepository _accountRepository;

  SettingsCubit(this._accountRepository) : super(const SettingsState());

  Future<void> loadUser() async {
    final either = await _accountRepository.getUser();
    if (either.isRight) {
      emit(state.copyWith(user: either.right));
    } else {
      // FIXME: handle error
      throw Exception('(SettingsCubit) could not load user');
    }
  }

  Future<void> changePasscode(String newPasscode) async {
    await _accountRepository.updatePasscode(newPasscode);
  }
}

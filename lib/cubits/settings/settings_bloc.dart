import 'package:coffeecard/model/account/user.dart';
import 'package:coffeecard/data/repositories/v1/account_repository.dart';
import 'package:coffeecard/widgets/components/entry/login/login_numpad.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AccountRepository _accountRepository;

  SettingsBloc(this._accountRepository) : super(UserLoading()) {
    on<LoadUser>((event, emit) async {
      // final user = await _accountRepository.getUser();
      final user = User(
          name: 'sa',
          email: 'han',
          rankMonth: 1,
          privacyActivated: true,
          requiredExp: 0,
          level: 0,
          rankAllTime: 0,
          rankSemester: 0);
      emit(UserLoaded(user));
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/models/account/update_user.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:coffeecard/models/occupation.dart';
import 'package:coffeecard/utils/encode_passcode.dart';
import 'package:equatable/equatable.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AccountRepository accountRepository;

  UserCubit(this.accountRepository) : super(UserLoading());

  Future<void> fetchUserDetails() async {
    emit(UserLoading());

    final either = await accountRepository.getUser();

    either.fold(
      (l) => emit(UserError(l.message)),
      (user) => emit(
        UserLoaded(
          user: user,
          occupation: user.occupation,
        ),
      ),
    );
  }

  Future<void> updateUser(UpdateUser user) async {
    if (state is! UserLoaded) {
      return;
    }

    final loadedState = state as UserLoaded;

    emit(
      UserUpdating(
        user: loadedState.user,
        occupation: loadedState.occupation,
      ),
    );

    final either = await accountRepository.updateUser(user);

    either.fold(
      (l) => emit(UserError(l.message)),
      (user) => emit(loadedState.copyWith(user: user)),
    );
  }

  Future<void> setUserPrivacy({required bool privacyActivated}) async {
    updateUser(UpdateUser(privacyActivated: privacyActivated));
  }

  Future<void> setUserName(String name) async {
    updateUser(UpdateUser(name: name));
  }

  Future<void> setUserEmail(String email) async {
    updateUser(UpdateUser(email: email));
  }

  Future<void> setUserPasscode(String passcode) async {
    updateUser(UpdateUser(encodedPasscode: encodePasscode(passcode)));
  }

  Future<void> setUserOccupation(int occupationId) async {
    updateUser(UpdateUser(occupationId: occupationId));
  }

  void requestAccountDeletion() {
    accountRepository.requestAccountDeletion();
  }
}

import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/data/repositories/v1/occupation_repository.dart';
import 'package:coffeecard/models/account/update_user.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:coffeecard/models/occupation.dart';
import 'package:coffeecard/utils/encode_passcode.dart';
import 'package:equatable/equatable.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AccountRepository _accountRepository;
  final OccupationRepository _occupationRepository;

  UserCubit(this._accountRepository, this._occupationRepository)
      : super(UserLoading());

  Future<void> fetchUserDetails() async {
    emit(UserLoading());
    refreshUserDetails();
  }

  Future<void> refreshUserDetails() async {
    final either = await _accountRepository.getUser();

    if (either.isRight) {
      _enrichUserWithOccupations(either.right);
    } else {
      emit(UserError(either.left.message));
    }
  }

  Future<void> _updateUser(UpdateUser user) async {
    if (state is! UserLoaded) {
      return;
    }
    final loadedState = state as UserLoaded;
    emit(
      UserUpdating(
        user: loadedState.user,
        occupations: loadedState.occupations,
      ),
    );

    final either = await _accountRepository.updateUser(user);

    either.caseOf((error) {
      emit(UserError(either.left.message));
    }, (user) async {
      // Refreshes twice as a work-around for
      // a backend bug that returns a user object with all ranks set to 0.
      await _enrichUserWithOccupations(either.right);

      // TODO(marfavi): remove fetchUserDetails when backend bug is fixed, https://github.com/AnalogIO/coffeecard_app/issues/378
      fetchUserDetails();
    });
  }

  Future<void> _enrichUserWithOccupations(User user) async {
    final List<Occupation> occupations;
    if (state is UserUpdating) {
      occupations = (state as UserUpdating).occupations;
    } else if (state is UserLoaded) {
      occupations = (state as UserLoaded).occupations;
    } else {
      // Fetches occupation info, if we have not cached it beforehand
      final either = await _occupationRepository.getOccupations();

      if (either.isRight) {
        occupations = either.right;
      } else {
        emit(UserError(either.left.message));
        return;
      }
    }

    final occupation =
        occupations.firstWhere((element) => element.id == user.occupationId);

    emit(
      UserLoaded(
        user: user.copyWith(
          occupation: OccupationInfo(occupation.shortName, occupation.fullName),
        ),
        occupations: occupations,
      ),
    );
  }

  Future<void> setUserPrivacy({required bool privacyActivated}) async {
    _updateUser(UpdateUser(privacyActivated: privacyActivated));
  }

  Future<void> setUserName(String name) async {
    _updateUser(UpdateUser(name: name));
  }

  Future<void> setUserEmail(String email) async {
    _updateUser(UpdateUser(email: email));
  }

  Future<void> setUserPasscode(String passcode) async {
    _updateUser(UpdateUser(encodedPasscode: encodePasscode(passcode)));
  }

  Future<void> setUserOccupation(int occupationId) async {
    _updateUser(UpdateUser(occupationId: occupationId));
  }

  void requestAccountDeletion() {
    _accountRepository.requestAccountDeletion();
  }
}

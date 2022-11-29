import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/data/repositories/v1/programme_repository.dart';
import 'package:coffeecard/models/account/update_user.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:coffeecard/models/programme.dart';
import 'package:coffeecard/utils/encode_passcode.dart';
import 'package:equatable/equatable.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AccountRepository _accountRepository;
  final ProgrammeRepository _programmeRepository;

  UserCubit(this._accountRepository, this._programmeRepository)
      : super(UserLoading());

  Future<void> fetchUserDetails() async {
    emit(UserLoading());
    refreshUserDetails();
  }

  Future<void> refreshUserDetails() async {
    final either = await _accountRepository.getUser();

    if (either.isRight) {
      _enrichUserWithProgrammes(either.right);
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
        programmes: loadedState.programmes,
      ),
    );

    final either = await _accountRepository.updateUser(user);

    either.caseOf((error) {
      emit(UserError(either.left.message));
    }, (user) async {
      // Refreshes twice as a work-around for
      // a backend bug that returns a user object with all ranks set to 0.
      await _enrichUserWithProgrammes(either.right);

      // TODO(marfavi): remove fetchUserDetails when backend bug is fixed, https://github.com/AnalogIO/coffeecard_app/issues/378
      fetchUserDetails();
    });
  }

  Future<void> _enrichUserWithProgrammes(User user) async {
    final List<Programme> programmes;
    if (state is UserUpdating) {
      programmes = (state as UserUpdating).programmes;
    } else if (state is UserLoaded) {
      programmes = (state as UserLoaded).programmes;
    } else {
      // Fetches the programme info, if we have not cached it beforehand
      final either = await _programmeRepository.getProgrammes();
      if (either.isRight) {
        programmes = either.right;
      } else {
        emit(UserError(either.left.message));
        return;
      }
    }

    final programme =
        programmes.firstWhere((element) => element.id == user.programmeId);

    emit(
      UserLoaded(
        user: user.copyWith(
          programme: ProgrammeInfo(programme.shortName, programme.fullName),
        ),
        programmes: programmes,
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

  Future<void> setUserProgramme(int programmeId) async {
    _updateUser(UpdateUser(programmeId: programmeId));
  }

  void requestAccountDeletion() {
    _accountRepository.requestAccountDeletion();
  }
}

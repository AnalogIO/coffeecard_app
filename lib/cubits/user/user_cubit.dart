import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/data/repositories/v1/programme_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/models/account/update_user.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:equatable/equatable.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AccountRepository _accountRepository;
  final ProgrammeRepository _programmeRepository;

  UserCubit(this._accountRepository, this._programmeRepository)
      : super(UserLoading());

  Future<void> fetchUserDetails() async {
    emit(UserLoading());

    final either = await _accountRepository.getUser();

    if (either.isRight) {
      _enrichUserWithProgrammes(either.right);
    } else {
      emit(UserError(either.left.errorMessage));
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

    if (either.isRight) {
      _enrichUserWithProgrammes(either.right);
    } else {
      emit(UserError(either.left.errorMessage));
    }
  }

  Future<void> _enrichUserWithProgrammes(User user) async {
    final List<ProgrammeDto> programmes;
    if (state is UserUpdating) {
      programmes = (state as UserUpdating).programmes;
    } else if (state is UserLoaded) {
      programmes = (state as UserLoaded).programmes;
    } else {
      // Fetches the programme info, if we have not cached it beforehand
      final either = await _programmeRepository.getProgramme();
      if (either.isRight) {
        programmes = either.right;
      } else {
        emit(UserError(either.left.errorMessage));
        return;
      }
    }

    final programme =
        programmes.firstWhere((element) => element.id == user.programmeId);

    emit(
      UserLoaded(
        user: user.copyWith(
          programme: ProgrammeInfo(programme.shortName!, programme.fullName!),
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
    _updateUser(UpdateUser(password: passcode));
  }

  void requestAccountDeletion() {
    _accountRepository.requestAccountDeletion();
  }
}

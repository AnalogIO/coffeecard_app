import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/data/repositories/v1/programme_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
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
      emit(UserLoaded(user: either.right));
    } else {
      emit(UserError(either.left.errorMessage));
    }
  }

  Future<void> fetchProgrammes(User user) async {
    emit(UserLoading());

    final either = await _programmeRepository.getProgramme();

    if (either.isRight) {
      final programmes = either.right;
      final programme =
          programmes.firstWhere((element) => element.id == user.programmeId);

      emit(
        UserLoaded(
          user: user.copyWith(
            programme: ProgrammeInfo(programme.shortName!, programme.fullName!),
          ),
          programmes: either.right,
        ),
      );
    } else {
      emit(UserError(either.left.errorMessage));
    }
  }

  Future<void> setUserPrivacy({required bool privacyActived}) async {
    emit(UserUpdating());

    final either =
        await _accountRepository.updateUserPrivacy(private: privacyActived);

    if (either.isRight) {
      emit(UserLoaded(user: either.right));
    } else {
      emit(UserError(either.left.errorMessage));
    }
  }

  Future<void> setUserName(String name) async {
    emit(UserUpdating());

    final either = await _accountRepository.updateUserName(name);

    if (either.isRight) {
      emit(UserLoaded(user: either.right));
    } else {
      emit(UserError(either.left.errorMessage));
    }
  }

  Future<void> setUserEmail(String email) async {
    emit(UserUpdating());

    final either = await _accountRepository.updateUserEmail(email);

    if (either.isRight) {
      emit(UserLoaded(user: either.right));
    } else {
      emit(UserError(either.left.errorMessage));
    }
  }

  Future<void> setUserPasscode(String passcode) async {
    emit(UserUpdating());

    final either = await _accountRepository.updateUserPasscode(passcode);

    if (either.isRight) {
      emit(UserLoaded(user: either.right));
    } else {
      emit(UserError(either.left.errorMessage));
    }
  }

  void requestAccountDeletion() {
    _accountRepository.requestAccountDeletion();
  }
}

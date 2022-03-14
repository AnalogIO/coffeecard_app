import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/data/repositories/v1/programme_repository.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/utils/either.dart';
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
      final either2 = await _enrichWithProgramme(either.right);

      if (either2.isRight) {
        emit(UserLoaded(either2.right));
      } else {
        emit(UserError(either2.left.errorMessage));
      }
    } else {
      emit(UserError(either.left.errorMessage));
    }
  }

  //FIXME: how can we avoid fetching every time?
  Future<Either<ApiError, User>> _enrichWithProgramme(User user) async {
    final programmes = await _programmeRepository.getProgramme();

    if (programmes.isRight) {
      final p = programmes.right
          .firstWhere((element) => element.id == user.programmeId);

      return Right(
        user.copyWith(
          programme: ProgrammeInfo(p.shortName!, p.fullName!),
        ),
      );
    }

    return Left(programmes.left);
  }

  Future<void> setUserPrivacy({required bool privacyActived}) async {
    emit(UserUpdating());

    final either =
        await _accountRepository.updateUserPrivacy(private: privacyActived);

    if (either.isRight) {
      final user2 = await _enrichWithProgramme(either.right);

      if (user2.isRight) {
        emit(UserLoaded(user2.right));
      } else {
        emit(UserError(user2.left.errorMessage));
      }
    } else {
      emit(UserError(either.left.errorMessage));
    }
  }

  Future<void> setUserName(String name) async {
    emit(UserUpdating());

    final either = await _accountRepository.updateUserName(name);

    if (either.isRight) {
      final user2 = await _enrichWithProgramme(either.right);

      if (user2.isRight) {
        emit(UserLoaded(user2.right));
      } else {
        emit(UserError(user2.left.errorMessage));
      }
    } else {
      emit(UserError(either.left.errorMessage));
    }
  }

  Future<void> setUserEmail(String email) async {
    emit(UserUpdating());

    final either = await _accountRepository.updateUserEmail(email);

    if (either.isRight) {
      final user2 = await _enrichWithProgramme(either.right);

      if (user2.isRight) {
        emit(UserLoaded(user2.right));
      } else {
        emit(UserError(user2.left.errorMessage));
      }
    } else {
      emit(UserError(either.left.errorMessage));
    }
  }

  Future<void> setUserPasscode(String passcode) async {
    emit(UserUpdating());

    final either = await _accountRepository.updateUserPasscode(passcode);

    if (either.isRight) {
      final user2 = await _enrichWithProgramme(either.right);

      if (user2.isRight) {
        emit(UserLoaded(user2.right));
      } else {
        emit(UserError(user2.left.errorMessage));
      }
    } else {
      emit(UserError(either.left.errorMessage));
    }
  }

  void requestAccountDeletion() {
    _accountRepository.requestAccountDeletion();
  }
}

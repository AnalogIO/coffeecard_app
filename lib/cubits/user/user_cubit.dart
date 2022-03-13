import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/data/repositories/v1/programme_repository.dart';
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
      var user = either.right;

      final programmes = await _programmeRepository.getProgramme();

      if (programmes.isRight) {
        final p = programmes.right
            .firstWhere((element) => element.id == user.programmeId);

        user = user.copyWith(
          programme: ProgrammeInfo(p.shortName!, p.fullName!),
        );
      }

      emit(UserLoaded(user));
    } else {
      emit(UserError(either.left.errorMessage));
    }
  }

  Future<void> setUserPrivacy({required bool privacyActived}) async {
    emit(UserUpdating());

    final either =
        await _accountRepository.updatePrivacy(private: privacyActived);

    if (either.isRight) {
      emit(UserLoaded(either.right));
    } else {
      emit(UserError(either.left.errorMessage));
    }
  }

  void requestAccountDeletion() {
    _accountRepository.requestAccountDeletion();
  }
}

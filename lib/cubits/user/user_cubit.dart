import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/v1/account_repository.dart';
<<<<<<< HEAD
import 'package:coffeecard/data/repositories/v1/programme_repository.dart';
=======
>>>>>>> Move user information to cubit (#157)
import 'package:coffeecard/models/account/user.dart';
import 'package:equatable/equatable.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AccountRepository accountRepository;
<<<<<<< HEAD
  final ProgrammeRepository programmeRepository;

  UserCubit(this.accountRepository, this.programmeRepository)
      : super(UserLoading());
=======

  UserCubit(this.accountRepository) : super(UserLoading());
>>>>>>> Move user information to cubit (#157)

  Future<void> fetchUserDetails() async {
    emit(UserLoading());

    final either = await accountRepository.getUser();

    if (either.isRight) {
<<<<<<< HEAD
      var user = either.right;

      final programmes = await programmeRepository.getProgramme();

      if (programmes.isRight) {
        final p = programmes.right
            .firstWhere((element) => element.id == user.programmeId);

        user = user.copyWith(
          programme: ProgrammeInfo(p.shortName!, p.fullName!),
        );
      }

      emit(UserLoaded(user));
=======
      emit(UserLoaded(either.right));
>>>>>>> Move user information to cubit (#157)
    } else {
      emit(UserError(either.left.errorMessage));
    }
  }

  Future<void> setUserPrivacy({required bool privacyActived}) async {
    emit(UserUpdating());

    final either =
        await accountRepository.updatePrivacy(private: privacyActived);

    if (either.isRight) {
      emit(UserLoaded(either.right));
    } else {
      emit(UserError(either.left.errorMessage));
    }
  }
}

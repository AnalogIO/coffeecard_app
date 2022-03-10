import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/v1/account_repository.dart';
import 'package:coffeecard/data/repositories/v1/programme_repository.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:equatable/equatable.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AccountRepository accountRepository;
  final ProgrammeRepository programmeRepository;

  UserCubit(this.accountRepository, this.programmeRepository)
      : super(UserLoading());

  Future<void> fetchUserDetails() async {
    emit(UserLoading());

    final either = await accountRepository.getUser();

    if (either.isRight) {
      var user = either.right;

      final programmes = await programmeRepository.getProgramme();

      if (programmes.isRight) {
        user = user.copyWith(
          programme: programmes.right.firstWhere((element) => element.id == user.programmeId).shortName,
        );
      }

      emit(UserLoaded(user));
    } else {
      emit(UserError(either.left.errorMessage));
    }
  }
}

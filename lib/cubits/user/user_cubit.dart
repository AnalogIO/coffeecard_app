import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/v1/account_repository.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:equatable/equatable.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AccountRepository accountRepository;

  UserCubit(this.accountRepository) : super(UserLoading());

  Future<void> fetchUserDetails() async {
    emit(UserLoading());

    final either = await accountRepository.getUser();

    if (either.isRight) {
      emit(UserLoaded(either.right));
    } else {
      emit(UserError(either.left.errorMessage));
    }
  }
}

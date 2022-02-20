import 'package:bloc/bloc.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/data/repositories/v1/account_repository.dart';
import 'package:coffeecard/models/account/user.dart';
import 'package:equatable/equatable.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AccountRepository accountRepository;

  UserCubit(this.accountRepository) : super(const UserState());

  Future<void> fetchUserDetails() async {
    emit(state.copyWith(isFetchingUser: true));

    final either = await accountRepository.getUser();

    if (either.isRight) {
      emit(state.copyWith(isFetchingUser: false, user: either.right));
    } else {
      emit(state.copyWith(isFetchingUser: false));
    }
  }

  int? getUserRankByPreset(StatisticsFilterCategory category) {
    switch (category.preset) {
      case 0:
        return state.user?.rankMonth;
      case 1:
        return state.user?.rankSemester;
      case 2:
        return state.user?.rankTotal;
      default:
        return null;
    }
  }
}

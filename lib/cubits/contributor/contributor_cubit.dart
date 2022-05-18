import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/external/contributor_repository.dart';
import 'package:coffeecard/models/contributor.dart';
import 'package:equatable/equatable.dart';

part 'contributor_state.dart';

class ContributorCubit extends Cubit<ContributorState> {
  final ContributorRepository _repository;

  ContributorCubit(this._repository) : super(ContributorLoading());

  Future<void> getContributors() async {
    emit(ContributorLoading());

    final either = await _repository.getContributors();

    if (either.isRight) {
      emit(ContributorLoaded(either.right));
    } else {
      emit(ContributorError(either.left.message));
    }
  }
}

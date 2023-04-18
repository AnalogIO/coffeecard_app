import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/external/contributor_repository.dart';
import 'package:coffeecard/models/contributor.dart';
import 'package:equatable/equatable.dart';

part 'contributor_state.dart';

class ContributorCubit extends Cubit<ContributorState> {
  ContributorCubit(this._repository) : super(const ContributorLoaded([]));
  final ContributorRepository _repository;

  Future<void> getContributors() async {
    final contributors = _repository.getContributors();

    emit(ContributorLoaded(contributors));
  }
}

import 'package:bloc/bloc.dart';
import 'package:coffeecard/features/contributor/data/datasources/contributor_repository.dart';
import 'package:coffeecard/features/contributor/domain/entities/contributor.dart';
import 'package:equatable/equatable.dart';

part 'contributor_state.dart';

class ContributorCubit extends Cubit<ContributorState> {
  final ContributorRepository repository;

  ContributorCubit({required this.repository})
      : super(const ContributorLoaded([]));

  Future<void> getContributors() async {
    final contributors = repository.getContributors();

    emit(ContributorLoaded(contributors));
  }
}

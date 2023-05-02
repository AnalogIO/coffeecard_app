import 'package:bloc/bloc.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/contributor/domain/entities/contributor.dart';
import 'package:coffeecard/features/contributor/domain/usecases/fetch_contributors.dart';
import 'package:equatable/equatable.dart';

part 'contributor_state.dart';

class ContributorCubit extends Cubit<ContributorState> {
  final FetchContributors fetchContributors;

  ContributorCubit({required this.fetchContributors})
      : super(const ContributorInitial());

  Future<void> getContributors() async {
    final contributors = await fetchContributors(NoParams());

    contributors.fold(
      (error) => emit(const ContributorLoaded([])),
      (contributors) => emit(ContributorLoaded(contributors)),
    );
  }
}

part of 'contributor_cubit.dart';

abstract class ContributorState extends Equatable {
  const ContributorState();
}

class ContributorInitial extends ContributorState {
  const ContributorInitial();

  @override
  List<Object?> get props => [];
}

class ContributorLoaded extends ContributorState {
  final List<Contributor> contributors;

  const ContributorLoaded(this.contributors);

  @override
  List<Object> get props => [contributors];
}

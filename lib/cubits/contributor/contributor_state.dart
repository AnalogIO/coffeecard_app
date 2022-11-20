part of 'contributor_cubit.dart';

abstract class ContributorState extends Equatable {
  const ContributorState();
}

class ContributorLoading extends ContributorState {
  const ContributorLoading();
  @override
  List<Object> get props => [];
}

class ContributorLoaded extends ContributorState {
  const ContributorLoaded(this.contributors);
  final List<Contributor> contributors;

  @override
  List<Object> get props => [contributors];
}

class ContributorError extends ContributorState {
  const ContributorError(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

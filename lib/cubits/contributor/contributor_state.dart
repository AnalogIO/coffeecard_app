part of 'contributor_cubit.dart';

abstract class ContributorState extends Equatable {
  const ContributorState();

  @override
  List<Object> get props => [];
}

class ContributorLoading extends ContributorState {}

class ContributorLoaded extends ContributorState {
  final List<Contributor> contributors;

  const ContributorLoaded(this.contributors);
  @override
  List<Object> get props => [contributors];
}

class ContributorError extends ContributorState {
  final String error;

  const ContributorError(this.error);

  @override
  List<Object> get props => [error];
}

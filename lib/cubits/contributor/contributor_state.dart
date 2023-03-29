part of 'contributor_cubit.dart';

abstract class ContributorState extends Equatable {
  const ContributorState();
}

class ContributorLoaded extends ContributorState {
  const ContributorLoaded(this.contributors);
  final List<Contributor> contributors;

  @override
  List<Object> get props => [contributors];
}

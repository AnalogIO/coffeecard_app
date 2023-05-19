part of 'occupation_cubit.dart';

sealed class OccupationState extends Equatable {
  const OccupationState();
}

class OccupationLoading extends OccupationState {
  const OccupationLoading();

  @override
  List<Object> get props => [];
}

class OccupationLoaded extends OccupationState {
  final List<Occupation> occupations;

  const OccupationLoaded({required this.occupations});

  @override
  List<Object> get props => [occupations];
}

class OccupationError extends OccupationState {
  final String message;

  const OccupationError({required this.message});

  @override
  List<Object> get props => [message];
}

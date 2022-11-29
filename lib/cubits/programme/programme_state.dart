part of 'programme_cubit.dart';

abstract class ProgrammeState extends Equatable {
  const ProgrammeState();
}

class ProgrammeLoading extends ProgrammeState {
  const ProgrammeLoading();

  @override
  List<Object> get props => [];
}

class ProgrammeLoaded extends ProgrammeState {
  final List<Programme> programmes;

  const ProgrammeLoaded({required this.programmes});

  @override
  List<Object> get props => [programmes];
}

class ProgrammeError extends ProgrammeState {
  final String message;

  const ProgrammeError(this.message);

  @override
  List<Object> get props => [message];
}

import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/v1/programme_repository.dart';
import 'package:coffeecard/models/programme.dart';
import 'package:equatable/equatable.dart';

part 'programme_state.dart';

class ProgrammeCubit extends Cubit<ProgrammeState> {
  final ProgrammeRepository programmeRepository;

  ProgrammeCubit({required this.programmeRepository})
      : super(const ProgrammeLoading());

  Future<void> getProgrammes() async {
    final either = await programmeRepository.getProgrammes();

    either.caseOf(
      (error) => emit(ProgrammeError(error.message)),
      (programmes) => emit(ProgrammeLoaded(programmes: programmes)),
    );
  }
}

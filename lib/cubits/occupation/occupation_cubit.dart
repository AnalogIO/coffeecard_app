import 'package:bloc/bloc.dart';
import 'package:coffeecard/data/repositories/v1/occupation_repository.dart';
import 'package:coffeecard/models/occupation.dart';
import 'package:equatable/equatable.dart';

part 'occupation_state.dart';

class OccupationCubit extends Cubit<OccupationState> {
  final OccupationRepository occupationRepository;

  OccupationCubit({required this.occupationRepository})
      : super(const OccupationLoading());

  Future<void> getOccupations() async {
    final either = await occupationRepository.getOccupations();

    either.caseOf(
      (error) => emit(OccupationError(error.message)),
      (occupations) => emit(OccupationLoaded(occupations: occupations)),
    );
  }
}

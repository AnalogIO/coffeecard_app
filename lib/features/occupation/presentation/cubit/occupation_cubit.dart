import 'package:bloc/bloc.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/occupation/domain/entities/occupation.dart';
import 'package:coffeecard/features/occupation/domain/usecases/get_occupations.dart';
import 'package:equatable/equatable.dart';

part 'occupation_state.dart';

class OccupationCubit extends Cubit<OccupationState> {
  final GetOccupations getOccupations;

  OccupationCubit({required this.getOccupations})
      : super(const OccupationLoading());

  Future<void> fetchOccupations() async {
    final either = await getOccupations(NoParams());

    either.fold(
      (error) => emit(OccupationError(error.reason)),
      (occupations) => emit(OccupationLoaded(occupations: occupations)),
    );
  }
}

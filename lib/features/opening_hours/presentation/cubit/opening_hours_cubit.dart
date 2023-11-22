import 'package:bloc/bloc.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/timeslot.dart';
import 'package:coffeecard/features/opening_hours/domain/usecases/get_opening_hours.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

part 'opening_hours_state.dart';

class OpeningHoursCubit extends Cubit<OpeningHoursState> {
  final GetOpeningHours fetchOpeningHours;

  OpeningHoursCubit({required this.fetchOpeningHours})
      : super(const OpeningHoursInitial());

  Future<void> getOpeninghours() async {
    final openingHours = fetchOpeningHours();

    emit(
      OpeningHoursLoaded(
        week: openingHours.allOpeningHours,
        today: openingHours.todaysOpeningHours,
      ),
    );
  }
}

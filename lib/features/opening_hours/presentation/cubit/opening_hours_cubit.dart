import 'package:bloc/bloc.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/timeslot.dart';
import 'package:coffeecard/features/opening_hours/domain/usecases/check_open_status.dart';
import 'package:coffeecard/features/opening_hours/domain/usecases/get_opening_hours.dart';
import 'package:equatable/equatable.dart';

part 'opening_hours_state.dart';

class OpeningHoursCubit extends Cubit<OpeningHoursState> {
  final GetOpeningHours fetchOpeningHours;
  final CheckOpenStatus checkIsOpen;

  OpeningHoursCubit({
    required this.fetchOpeningHours,
    required this.checkIsOpen,
  }) : super(const OpeningHoursInitial());

  Future<void> getOpeninghours() async {
    final openingHours = fetchOpeningHours();
    final isOpen = checkIsOpen();

    emit(
      OpeningHoursLoaded(
        isOpen: isOpen,
        openingHours: openingHours.allOpeningHours,
        todaysOpeningHours: openingHours.todaysOpeningHours,
      ),
    );
  }
}

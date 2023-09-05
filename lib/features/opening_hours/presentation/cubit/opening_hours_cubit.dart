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

    final todaysOpeningHours = openingHours[DateTime.now().weekday]!;

    emit(
      OpeningHoursLoaded(
        isOpen: checkIsOpen(),
        openingHours: openingHours,
        todaysOpeningHours: todaysOpeningHours,
      ),
    );
  }
}

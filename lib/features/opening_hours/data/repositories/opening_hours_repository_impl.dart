import 'package:coffeecard/core/external/date_service.dart';
import 'package:coffeecard/features/opening_hours/data/datasources/opening_hours_local_data_source.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/opening_hours.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/timeslot.dart';
import 'package:coffeecard/features/opening_hours/domain/repositories/opening_hours_repository.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class OpeningHoursRepositoryImpl implements OpeningHoursRepository {
  final OpeningHoursLocalDataSource dataSource;
  final DateService dateService;

  OpeningHoursRepositoryImpl({
    required this.dataSource,
    required this.dateService,
  });

  @override
  OpeningHours getOpeningHours() {
    final allOpeningHours = dataSource.getOpeningHours();
    final currentWeekday = dateService.currentDateTime.weekday;

    final todaysOpeningHours = Option.fromNullable(
      allOpeningHours[currentWeekday],
    );

    return OpeningHours(
      allOpeningHours: allOpeningHours,
      todaysOpeningHours: todaysOpeningHours,
    );
  }

  @override
  bool isOpen() {
    final todaysOpeningHours = getOpeningHours().todaysOpeningHours;
    final currentTimeOfDay =
        TimeOfDay.fromDateTime(dateService.currentDateTime);

    return todaysOpeningHours.match(
      () => false,
      currentTimeOfDay.isInTimeslot,
    );
  }
}

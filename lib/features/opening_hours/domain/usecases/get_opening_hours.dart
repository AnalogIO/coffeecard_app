import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/opening_hours/data/datasources/opening_hours_remote_data_source.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/opening_hours.dart';
import 'package:fpdart/fpdart.dart';

class GetOpeningHours implements UseCase<OpeningHours, NoParams> {
  final OpeningHoursRemoteDataSource dataSource;

  GetOpeningHours({required this.dataSource});

  @override
  Future<Either<Failure, OpeningHours>> call(NoParams params) {
    return dataSource.getOpeningHours();
  }
}

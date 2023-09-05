import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/opening_hours/data/datasources/opening_hours_remote_data_source.dart';
import 'package:fpdart/fpdart.dart';

class CheckOpenStatus implements UseCase<bool, NoParams> {
  final OpeningHoursRemoteDataSource dataSource;

  CheckOpenStatus({required this.dataSource});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return dataSource.isOpen();
  }
}

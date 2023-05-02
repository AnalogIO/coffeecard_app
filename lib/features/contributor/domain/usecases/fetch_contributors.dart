import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/contributor/data/datasources/contributor_local_data_source.dart';
import 'package:coffeecard/features/contributor/domain/entities/contributor.dart';
import 'package:dartz/dartz.dart';

class FetchContributors implements UseCase<List<Contributor>, NoParams> {
  final ContributorLocalDataSource dataSource;

  FetchContributors({required this.dataSource});

  @override
  Future<Either<Failure, List<Contributor>>> call(NoParams params) {
    return Future.value(Right(dataSource.getContributors()));
  }
}

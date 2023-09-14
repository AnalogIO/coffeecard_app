import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/contributor/data/datasources/contributor_local_data_source.dart';
import 'package:coffeecard/features/contributor/domain/entities/contributor.dart';
import 'package:fpdart/fpdart.dart';

class FetchContributors {
  final ContributorLocalDataSource dataSource;

  FetchContributors({required this.dataSource});

  Future<Either<Failure, List<Contributor>>> call() {
    return Future.value(Right(dataSource.getContributors()));
  }
}

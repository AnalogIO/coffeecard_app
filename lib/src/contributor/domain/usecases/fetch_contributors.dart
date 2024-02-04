import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/contributor.dart';
import 'package:fpdart/fpdart.dart';

class FetchContributors {
  final ContributorLocalDataSource dataSource;

  FetchContributors({required this.dataSource});

  Future<Either<Failure, List<Contributor>>> call() {
    return Future.value(Right(dataSource.getContributors()));
  }
}

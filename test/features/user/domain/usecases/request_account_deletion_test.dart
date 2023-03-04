import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/user/domain/repositories/user_repository.dart';
import 'package:coffeecard/features/user/domain/usecases/request_account_deletion.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'request_account_deletion_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository repository;
  late RequestAccountDeletion usecase;

  setUp(() {
    repository = MockUserRepository();
    usecase = RequestAccountDeletion(repository: repository);
  });

  test('should call repository', () async {
    // arrange
    when(repository.requestAccountDeletion()).thenAnswer(
      (_) async => const Right(null),
    );

    // act
    await usecase(NoParams());

    // assert
    verify(repository.requestAccountDeletion());
  });
}

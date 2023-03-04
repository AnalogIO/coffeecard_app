import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/occupation/domain/entities/occupation.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:coffeecard/features/user/domain/repositories/user_repository.dart';
import 'package:coffeecard/features/user/domain/usecases/get_user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_user_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository repository;
  late GetUser usecase;

  setUp(() {
    repository = MockUserRepository();
    usecase = GetUser(repository: repository);
  });

  test('should call repository', () async {
    // arrange
    when(repository.getUser()).thenAnswer(
      (_) async => const Right(
        User(
          id: 0,
          name: 'name',
          email: 'email',
          privacyActivated: false,
          occupation: Occupation.empty(),
          rankMonth: 0,
          rankSemester: 0,
          rankTotal: 0,
        ),
      ),
    );

    // act
    await usecase(NoParams());

    // assert
    verify(repository.getUser());
  });
}

import 'package:coffeecard/features/occupation/domain/entities/occupation.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:coffeecard/features/user/domain/repositories/user_repository.dart';
import 'package:coffeecard/features/user/domain/usecases/update_user_details.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_user_details_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository repository;
  late UpdateUserDetails usecase;

  setUp(() {
    repository = MockUserRepository();
    usecase = UpdateUserDetails(repository: repository);
  });

  test('should call repository', () async {
    // arrange
    when(repository.updateUserDetails(any)).thenAnswer(
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
    await usecase(
      const Params(
        name: 'name',
        email: 'email',
        encodedPasscode: 'encodedPasscode',
        privacyActivated: false,
        occupationId: 0,
      ),
    );

    // assert
    verify(repository.updateUserDetails(any));
  });
}

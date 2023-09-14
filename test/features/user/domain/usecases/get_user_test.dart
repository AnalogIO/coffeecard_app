import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/occupation/domain/entities/occupation.dart';
import 'package:coffeecard/features/user/data/datasources/user_remote_data_source.dart';
import 'package:coffeecard/features/user/data/models/user_model.dart';
import 'package:coffeecard/features/user/domain/entities/role.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:coffeecard/features/user/domain/usecases/get_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_user_test.mocks.dart';

@GenerateMocks([UserRemoteDataSource])
void main() {
  late MockUserRemoteDataSource dataSource;
  late GetUser usecase;

  setUp(() {
    dataSource = MockUserRemoteDataSource();
    usecase = GetUser(dataSource: dataSource);

    provideDummy<Either<NetworkFailure, User>>(
      const Left(ConnectionFailure()),
    );
  });

  test('should call repository', () async {
    // arrange
    when(dataSource.getUser()).thenAnswer(
      (_) async => const Right(
        UserModel(
          id: 0,
          name: 'name',
          email: 'email',
          privacyActivated: false,
          occupation: Occupation.empty(),
          rankMonth: 0,
          rankSemester: 0,
          rankTotal: 0,
          role: Role.customer,
        ),
      ),
    );

    // act
    await usecase();

    // assert
    verify(dataSource.getUser());
  });
}

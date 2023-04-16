import 'package:coffeecard/features/occupation/domain/entities/occupation.dart';
import 'package:coffeecard/features/user/data/datasources/user_remote_data_source.dart';
import 'package:coffeecard/features/user/data/models/user_model.dart';
import 'package:coffeecard/features/user/domain/entities/role.dart';
import 'package:coffeecard/features/user/domain/entities/roles.dart';
import 'package:coffeecard/features/user/domain/usecases/update_user_details.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'update_user_details_test.mocks.dart';

@GenerateMocks([UserRemoteDataSource])
void main() {
  late MockUserRemoteDataSource dataSource;
  late UpdateUserDetails usecase;

  setUp(() {
    dataSource = MockUserRemoteDataSource();
    usecase = UpdateUserDetails(dataSource: dataSource);
  });

  test('should call repository', () async {
    // arrange
    when(dataSource.updateUserDetails(any)).thenAnswer(
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
          role: Role(Roles.customer),
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
    verify(dataSource.updateUserDetails(any));
  });
}

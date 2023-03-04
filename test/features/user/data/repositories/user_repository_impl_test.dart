import 'package:coffeecard/core/errors/exceptions.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/occupation/domain/entities/occupation.dart';
import 'package:coffeecard/features/user/data/datasources/user_remote_data_source.dart';
import 'package:coffeecard/features/user/data/models/user_model.dart';
import 'package:coffeecard/features/user/data/repositories/user_repository_impl.dart';
import 'package:coffeecard/features/user/domain/repositories/user_repository.dart';
import 'package:coffeecard/models/account/update_user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_repository_impl_test.mocks.dart';

@GenerateMocks([UserRemoteDataSource])
void main() {
  late MockUserRemoteDataSource remoteDataSource;
  late UserRepository repository;

  setUp(() {
    remoteDataSource = MockUserRemoteDataSource();
    repository = UserRepositoryImpl(remoteDataSource: remoteDataSource);
  });

  const tUserModel = UserModel(
    id: 0,
    name: 'name',
    email: 'email',
    privacyActivated: false,
    occupation: Occupation.empty(),
    rankMonth: 0,
    rankSemester: 0,
    rankTotal: 0,
  );

  group('getUser', () {
    test('should return [User] when data source succeeds', () async {
      // arrange
      when(remoteDataSource.getUser()).thenAnswer(
        (_) async => tUserModel,
      );

      // act
      final actual = await repository.getUser();

      // assert
      expect(actual, const Right(tUserModel));
    });

    test('should return [ServerFailure] when data source fails', () async {
      // arrange
      when(remoteDataSource.getUser()).thenThrow(
        ServerException(error: 'some error'),
      );

      // act
      final actual = await repository.getUser();

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });
  });

  group('requestAccountDeletion', () {
    test('should return [void] when data source succeeds', () async {
      // arrange
      when(remoteDataSource.requestAccountDeletion()).thenAnswer(
        (_) => Future.value(),
      );

      // act
      final actual = await repository.requestAccountDeletion();

      // assert
      expect(actual, const Right(null));
    });

    test('should return [ServerFailure] when data source fails', () async {
      // arrange
      when(remoteDataSource.requestAccountDeletion()).thenThrow(
        ServerException(error: 'some error'),
      );

      // act
      final actual = await repository.requestAccountDeletion();

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });
  });

  group('updateUserDetails', () {
    test('should return [User] when data source succeeds', () async {
      // arrange
      when(remoteDataSource.updateUserDetails(any)).thenAnswer(
        (_) async => tUserModel,
      );

      // act
      final actual = await repository.updateUserDetails(const UpdateUser());

      // assert
      expect(actual, const Right(tUserModel));
    });

    test('should return [ServerFailure] when data source fails', () async {
      // arrange
      when(remoteDataSource.updateUserDetails(any)).thenThrow(
        ServerException(error: 'some error'),
      );

      // act
      final actual = await repository.updateUserDetails(const UpdateUser());

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/register/domain/usecases/register_user.dart';
import 'package:coffeecard/features/register/presentation/cubit/register_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'register_cubit_test.mocks.dart';

@GenerateMocks([RegisterUser])
void main() {
  late MockRegisterUser registerUser;
  late RegisterCubit cubit;

  setUp(() {
    registerUser = MockRegisterUser();
    cubit = RegisterCubit(
      registerUser: registerUser,
    );

    provideDummy<Either<Failure, Unit>>(
      const Left(ConnectionFailure()),
    );
  });

  group('register', () {
    const testError = 'some error';

    blocTest(
      'should emit [Error] if use case fails',
      build: () => cubit,
      setUp: () => when(
        registerUser(
          email: anyNamed('email'),
          encodedPasscode: anyNamed('encodedPasscode'),
          name: anyNamed('name'),
          occupationId: anyNamed('occupationId'),
        ),
      ).thenAnswer((_) async => const Left(ServerFailure(testError, 500))),
      act: (_) => cubit.register('name', 'email', 'passcode', 0),
      expect: () => [RegisterError(testError)],
    );

    blocTest(
      'should emit [Success] if use case succeeds',
      build: () => cubit,
      setUp: () {
        when(
          registerUser(
            email: anyNamed('email'),
            encodedPasscode: anyNamed('encodedPasscode'),
            name: anyNamed('name'),
            occupationId: anyNamed('occupationId'),
          ),
        ).thenAnswer((_) async => const Right(unit));
      },
      act: (_) => cubit.register('name', 'email', 'passcode', 0),
      expect: () => [RegisterSuccess()],
    );
  });
}

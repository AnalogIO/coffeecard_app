import 'package:chopper/chopper.dart' as chopper;
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/data/storage/secure_storage.dart';
import 'package:coffeecard/models/account/authenticated_user.dart';
import 'package:coffeecard/utils/reactivation_authenticator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';

import 'package:mockito/mockito.dart';

import 'reactivation_authenticator_test.mocks.dart';

chopper.Response<T> _responseFromStatusCode<T>(
  int statusCode, {
  T? body,
}) {
  return chopper.Response(
    http.Response('', statusCode),
    body,
  );
}

chopper.Request _requestFromMethod(String method) {
  return chopper.Request(method, Uri.parse('test'), Uri.parse('basetest'));
}

class _FakeGetIt extends Fake implements GetIt {
  _FakeGetIt.fromMockedObjects({
    required this.mockAuthenticationCubit,
    required this.mockAccountRepository,
    required this.mockSecureStorage,
    required this.mockLogger,
  });

  final MockAuthenticationCubit mockAuthenticationCubit;
  final MockAccountRepository mockAccountRepository;
  final MockSecureStorage mockSecureStorage;
  final MockLogger mockLogger;

  @override
  // We don't care about the parameter types, so we can ignore the warning
  // ignore: type_annotate_public_apis
  T call<T extends Object>({String? instanceName, param1, param2, Type? type}) {
    return get<T>(
      instanceName: instanceName,
      param1: param1,
      param2: param2,
      type: type,
    );
  }

  @override
  // We don't care about the parameter types, so we can ignore the warning
  // ignore: type_annotate_public_apis
  T get<T extends Object>({String? instanceName, param1, param2, Type? type}) {
    return switch (T) {
      AuthenticationCubit => mockAuthenticationCubit,
      AccountRepository => mockAccountRepository,
      SecureStorage => mockSecureStorage,
      Logger => mockLogger,
      _ => throw UnimplementedError('Mock for $T not implemented.'),
    } as T;
  }

  /// Given a mocked type, get the mocked object for the given type.
  T getMock<T extends Mock>() {
    return switch (T) {
      MockAuthenticationCubit => mockAuthenticationCubit,
      MockAccountRepository => mockAccountRepository,
      MockSecureStorage => mockSecureStorage,
      MockLogger => mockLogger,
      _ => throw UnimplementedError('Mock for $T not implemented.'),
    } as T;
  }
}

@GenerateNiceMocks([
  MockSpec<AuthenticationCubit>(),
  MockSpec<AccountRepository>(),
  MockSpec<SecureStorage>(),
  MockSpec<Logger>(),
])
void main() {
  late _FakeGetIt serviceLocator;
  late MockAuthenticationCubit authenticationCubit;
  late MockAccountRepository accountRepository;
  late MockSecureStorage secureStorage;

  late ReactivationAuthenticator authenticator;

  setUp(() {
    serviceLocator = _FakeGetIt.fromMockedObjects(
      mockAuthenticationCubit: MockAuthenticationCubit(),
      mockAccountRepository: MockAccountRepository(),
      mockSecureStorage: MockSecureStorage(),
      mockLogger: MockLogger(),
    );

    authenticationCubit = serviceLocator.getMock<MockAuthenticationCubit>();
    accountRepository = serviceLocator.getMock<MockAccountRepository>();
    secureStorage = serviceLocator.getMock<MockSecureStorage>();

    authenticator = ReactivationAuthenticator(serviceLocator: serviceLocator);
  });

  test(
    'GIVEN a response with status code other than 401 '
    'WHEN authenticate is called '
    'THEN it should return null',
    () async {
      // Arrange
      final request = _requestFromMethod('GET');
      final response = _responseFromStatusCode(200);

      // Act
      final result = await authenticator.authenticate(request, response);

      // Assert
      expect(result, isNull);
    },
  );

  test(
    'GIVEN '
    '1) a response with status code 401, '
    '2) no prior calls to authenticate, '
    'and 3) no stored login credentials '
    'WHEN authenticate is called '
    'THEN it should return null',
    () async {
      // Arrange
      final request = _requestFromMethod('GET');
      final response = _responseFromStatusCode(401);

      // Act
      final result = await authenticator.authenticate(request, response);

      // Assert
      expect(result, isNull);
    },
  );

  test(
    'GIVEN '
    '1) response with status code 401, '
    '2) no prior calls to authenticate, '
    'and 3) stored login credentials that are invalid '
    'WHEN authenticate is called '
    'THEN '
    '1) AccountRepository.login should be called with the stored credentials, '
    '2) AuthenticationCubit.unauthenticated should be called, '
    'and 3) it should return null',
    () async {
      // Arrange
      const email = 'email';
      const encodedPasscode = 'encodedPasscode';
      const token = 'token';
      const reason = 'invalid credentials';

      when(secureStorage.readEmail()).thenAnswer(
        (_) async => email,
      );
      when(secureStorage.readEncodedPasscode()).thenAnswer(
        (_) async => encodedPasscode,
      );
      when(secureStorage.getAuthenticatedUser()).thenAnswer(
        (_) async => const AuthenticatedUser(email: email, token: token),
      );

      when(accountRepository.login(email, encodedPasscode)).thenAnswer(
        (_) async => left(const ServerFailure(reason)),
      );

      final request = _requestFromMethod('GET');
      final response = _responseFromStatusCode(401);

      // Act
      final result = await authenticator.authenticate(request, response);

      // Assert
      verify(accountRepository.login(email, encodedPasscode)).called(1);
      verify(authenticationCubit.unauthenticated()).called(1);
      expect(result, isNull);
      verifyNoMoreInteractions(accountRepository);
      verifyNoMoreInteractions(authenticationCubit);
    },
  );

  test(
    'GIVEN '
    '1) a response with status code 401, '
    '2) no prior calls to authenticate, '
    'and 3) valid stored login credentials '
    'WHEN authenticate is called '
    'THEN '
    '1) AccountRepository.login should be called with the stored credentials, '
    '2) SecureStorage.updateToken should be called, '
    'and 3) it should return a new request with the updated token',
    () async {
      // Arrange
      const email = 'email';
      const encodedPasscode = 'encodedPasscode';
      const oldToken = 'oldToken';
      const newToken = 'newToken';

      when(secureStorage.readEmail()).thenAnswer(
        (_) async => email,
      );
      when(secureStorage.readEncodedPasscode()).thenAnswer(
        (_) async => encodedPasscode,
      );
      when(secureStorage.readToken()).thenAnswer(
        (_) async => oldToken,
      );

      when(accountRepository.login(email, encodedPasscode)).thenAnswer(
        (_) async => right(
          const AuthenticatedUser(email: email, token: newToken),
        ),
      );

      final request = _requestFromMethod('GET');
      final response = _responseFromStatusCode(401);

      // Act
      final result = await authenticator.authenticate(request, response);

      // Assert
      verify(accountRepository.login(email, encodedPasscode)).called(1);
      verifyNoMoreInteractions(accountRepository);

      verify(secureStorage.readEmail()).called(1);
      verify(secureStorage.readEncodedPasscode()).called(1);
      verify(secureStorage.updateToken(newToken)).called(1);
      verifyNoMoreInteractions(secureStorage);

      expect(result, isNotNull);
      expect(result!.headers['Authorization'], 'Bearer $newToken');
    },
  );

  test(
    'GIVEN '
    '1) a response with status code 401, '
    '2) a prior call to authenticate is running, '
    'and 3) and stored valid login credentials exist '
    'WHEN authenticate is called '
    'THEN it should return a new request with the updated token',
    () async {
      // Arrange
      const token = 'token';

      when(secureStorage.readToken()).thenAnswer(
        (_) async => token,
      );

      final request = _requestFromMethod('GET');
      final response = _responseFromStatusCode(401);

      // Simulate a prior call to authenticate is running
      authenticator.authenticate(request, response);

      // Act
      final result = await authenticator.authenticate(request, response);

      // Assert
      expect(result, isNotNull);
      expect(result!.headers['Authorization'], token);
    },
  );

  test(
    'GIVEN '
    '1) a response with status code 401, '
    '2) a prior call to authenticate is running, '
    'and 3) and no token exists in storage '
    'WHEN authenticate is called '
    'THEN it should return null',
    () async {
      // Arrange
      when(secureStorage.readToken()).thenAnswer(
        (_) async => null,
      );

      final request = _requestFromMethod('GET');
      final response = _responseFromStatusCode(401);

      // Simulate a prior call to authenticate is running
      authenticator.authenticate(request, response);

      // Act
      final result = await authenticator.authenticate(request, response);

      // Assert
      expect(result, isNull);
    },
  );
}

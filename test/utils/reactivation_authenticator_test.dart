import 'package:chopper/chopper.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/data/storage/secure_storage.dart';
import 'package:coffeecard/utils/reactivation_authenticator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'reactivation_authenticator_test.mocks.dart';

class MockGetIt extends Mock implements GetIt {}

@GenerateMocks([SecureStorage, AuthenticationCubit, Logger, AccountRepository])
void main() {
  late MockGetIt mockServiceLocator;
  late MockSecureStorage mockSecureStorage;
  late MockAuthenticationCubit mockAuthenticationCubit;
  late MockLogger mockLogger;
  late MockAccountRepository mockAccountRepository;
  late ReactivationAuthenticator authenticator;

  setUp(() {
    mockServiceLocator = MockGetIt();
    mockSecureStorage = MockSecureStorage();
    mockAuthenticationCubit = MockAuthenticationCubit();
    mockLogger = MockLogger();
    mockAccountRepository = MockAccountRepository();

    when(mockServiceLocator<SecureStorage>()).thenReturn(mockSecureStorage);
    when(mockServiceLocator<AuthenticationCubit>())
        .thenReturn(mockAuthenticationCubit);
    when(mockServiceLocator<Logger>()).thenReturn(mockLogger);
    when(mockServiceLocator<AccountRepository>())
        .thenReturn(mockAccountRepository);

    authenticator = ReactivationAuthenticator(mockServiceLocator);
  });

  group('ReactivationAuthenticator', () {
    test('authenticate - non 401 response', () async {
      final request = Request(
        'GET',
        Uri.parse('https://example.com'),
        Uri.parse('https://example.com'),
      );
      // FIXME Finish the code!
      // final response = const Response(
      //   'body',
      //   200,
      //   request: request,
      // );

      // final result = await authenticator.authenticate(request, response);
      // expect(result, null);
    });

    // Add more tests for other scenarios, such as:
    // - refreshToken succeeds
    // - refreshToken fails
    // - refreshToken called when another refreshToken call is in progress
  });
}

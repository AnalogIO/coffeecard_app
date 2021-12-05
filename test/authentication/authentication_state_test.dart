import 'package:coffeecard/blocs/authentication/authentication_bloc.dart';
import 'package:coffeecard/model/account/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// ignore: must_be_immutable, avoid_implementing_value_types
class MockUser extends Mock implements User {}

void main() {
  group('AuthenticationState', () {
    group('AuthenticationState.unknown', () {
      test('supports value comparisons', () {
        expect(
          const AuthState.unknown(),
          const AuthState.unknown(),
        );
      });
    });

    group('AuthenticationState.authenticated', () {
      test('supports value comparisons', () {
        final user = MockUser();
        expect(
          AuthState.authenticated(user),
          AuthState.authenticated(user),
        );
      });
    });

    group('AuthenticationState.unauthenticated', () {
      test('supports value comparisons', () {
        expect(
          const AuthState.unauthenticated(),
          const AuthState.unauthenticated(),
        );
      });
    });
  });
}

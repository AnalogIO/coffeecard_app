import 'package:coffeecard/blocs/authentication/authentication_bloc.dart';
import 'package:coffeecard/persistence/repositories/authentication_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthenticationEvent', () {
    group('LoggedOut', () {
      test('supports value comparisons', () {
        expect(
          AuthenticationLogoutRequested(),
          AuthenticationLogoutRequested(),
        );
      });
    });

    group('AuthenticationStatusChanged', () {
      test('supports value comparisons', () {
        expect(
          const AuthenticationStatusChanged(AuthenticationStatus.unknown),
          const AuthenticationStatusChanged(AuthenticationStatus.unknown),
        );
      });
    });
  });
}

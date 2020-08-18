import 'package:coffeecard/blocs/authentication/authentication_bloc.dart';
import 'package:coffeecard/persistence/repositories/authentication_repository.dart';
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
          AuthenticationStatusChanged(AuthenticationStatus.unknown),
          AuthenticationStatusChanged(AuthenticationStatus.unknown),
        );
      });
    });
  });
}

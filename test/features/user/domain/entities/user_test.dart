import 'package:coffeecard/features/occupation/domain/entities/occupation.dart';
import 'package:coffeecard/features/user/domain/entities/role.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  User userWithRole(Role role) {
    return User(
      id: 1,
      name: 'Test User',
      email: '',
      privacyActivated: false,
      occupation: const Occupation.empty(),
      rankMonth: 1,
      rankSemester: 1,
      rankTotal: 1,
      role: role,
    );
  }

  group('User', () {
    test(
      'hasBaristaPerks should return true for barista, manager, and board roles',
      () {
        final barista = userWithRole(Role.barista);
        final manager = userWithRole(Role.manager);
        final board = userWithRole(Role.board);

        expect(barista.hasBaristaPerks, isTrue);
        expect(manager.hasBaristaPerks, isTrue);
        expect(board.hasBaristaPerks, isTrue);
      },
    );

    test('hasBaristaPerks should return false for customer role', () {
      final customer = userWithRole(Role.customer);

      expect(customer.hasBaristaPerks, isFalse);
    });
  });
}

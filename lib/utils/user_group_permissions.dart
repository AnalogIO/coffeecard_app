import 'package:coffeecard/models/account/user.dart';

bool hasBaristaPerks(User user) {
  switch (user.userGroup) {
    case UserGroup.Barista:
    case UserGroup.Manager:
    case UserGroup.Board:
      return true;
    case UserGroup.Customer:
      return false;
  }
  throw RangeError('Unknown user group');
}

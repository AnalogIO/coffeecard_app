import 'package:coffeecard/models/account/user.dart';

bool hasBaristaPerks(User user) {
  return [UserGroup.Barista, UserGroup.Manager, UserGroup.Board]
      .contains(user.userGroup);
}

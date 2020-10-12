import 'package:coffeecard/model/account/register_user.dart';
import 'package:coffeecard/model/account/user.dart';
import 'package:coffeecard/model/account/email.dart';
import 'package:coffeecard/model/account/user_id.dart';


abstract class AccountRepository {
  Future login(String userName, String password);
  Future register(RegisterUser register);
  Future<User> getUser();
  Future<User> updateUser(User user);
  Future<User> getUserById(UserId id);
  Future<void> forgottenPassword(Email email);
}
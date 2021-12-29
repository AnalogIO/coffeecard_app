import 'package:coffeecard/widgets/components/entry/register/register_name_text_field.dart';
import 'package:coffeecard/widgets/pages/entry/register/register_page.dart';

class RegisterNamePage extends RegisterPage {
  RegisterNamePage()
      : super(
          appBarTitle: 'Register',
          title: 'Enter your name',
          body: RegisterNameTextField(),
        );
}

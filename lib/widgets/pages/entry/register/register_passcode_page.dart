import 'package:coffeecard/widgets/components/entry/register/register_passcode_text_fields.dart';
import 'package:coffeecard/widgets/pages/entry/register/register_page.dart';

class RegisterPasscodePage extends RegisterPage {
  RegisterPasscodePage()
      : super(
          appBarTitle: 'Register',
          title: 'Enter a passcode',
          body: RegisterPasscodeTextFields(),
        );
}

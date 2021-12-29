import 'package:coffeecard/widgets/components/entry/register/register_email_text_field.dart';
import 'package:coffeecard/widgets/pages/entry/register/register_page.dart';

class RegisterEmailPage extends RegisterPage {
  RegisterEmailPage()
      : super(
          appBarTitle: 'Register',
          title: 'Enter your email',
          body: RegisterEmailTextField(),
        );
}

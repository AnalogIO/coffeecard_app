import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/entry/register/register_email_body.dart';
import 'package:coffeecard/widgets/pages/register/register_page.dart';

class RegisterEmailPage extends RegisterPage {
  const RegisterEmailPage()
      : super(
          sectionTitle: Strings.registerEmailTitle,
          body: const RegisterEmailBody(),
        );
}

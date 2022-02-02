import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/entry/register/register_name_text_field.dart';
import 'package:coffeecard/widgets/pages/register/register_page.dart';

class RegisterNamePage extends RegisterPage {
  const RegisterNamePage()
      : super(
          sectionTitle: Strings.registerNameTitle,
          body: const RegisterNameTextField(),
        );
}

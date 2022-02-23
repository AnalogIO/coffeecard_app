import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/entry/register/register_passcode_body.dart';
import 'package:coffeecard/widgets/pages/register/register_page.dart';

class RegisterPasscodePage extends RegisterPage {
  const RegisterPasscodePage()
      : super(
          sectionTitle: Strings.registerPasscodeTitle,
          body: const RegisterPasscodeBody(),
        );
}

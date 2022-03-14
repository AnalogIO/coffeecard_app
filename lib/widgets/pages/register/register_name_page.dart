import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/widgets/components/entry/register/name_body.dart';
import 'package:coffeecard/widgets/pages/register/register_page.dart';

class RegisterNamePage extends RegisterPage {
  RegisterNamePage()
      : super(
          sectionTitle: Strings.registerNameTitle,
          body: NameBody(
            onSubmit: (context, email) {},
          ),
        );
}

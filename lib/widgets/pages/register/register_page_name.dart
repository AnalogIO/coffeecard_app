import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/utils/fast_slide_transition.dart';
import 'package:coffeecard/widgets/components/entry/register/name_body.dart';
import 'package:coffeecard/widgets/pages/register/register_page_base.dart';
import 'package:flutter/material.dart';

class RegisterPageName extends StatelessWidget {
  const RegisterPageName();

  static Route get route =>
      FastSlideTransition(child: const RegisterPageName());

  @override
  Widget build(BuildContext context) {
    return const RegisterPageBase(
      sectionTitle: Strings.registerNameTitle,
      body: NameBody(),
    );
  }
}

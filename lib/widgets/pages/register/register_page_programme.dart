import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/models/programme.dart';
import 'package:coffeecard/utils/fast_slide_transition.dart';
import 'package:coffeecard/widgets/components/occupation_selection.dart';
import 'package:coffeecard/widgets/components/tickets/rounded_button.dart';
import 'package:coffeecard/widgets/pages/register/register_page_name.dart';
import 'package:flutter/material.dart';

class RegisterPageProgramme extends StatefulWidget {
  const RegisterPageProgramme({
    required this.email,
    required this.passcode,
  });

  final String email;
  final String passcode;

  static Route routeWith({required String email, required String passcode}) {
    return FastSlideTransition(
      child: RegisterPageProgramme(email: email, passcode: passcode),
    );
  }

  @override
  State<RegisterPageProgramme> createState() => _RegisterPageProgrammeState();
}

class _RegisterPageProgrammeState extends State<RegisterPageProgramme> {
  var _selected = 0;

  @override
  Widget build(BuildContext context) {
    const programmes = [
      Programme(id: 0, shortName: 'test', fullName: 'fullname')
    ];

    return Column(
      children: [
        OccupationSelection(
          programmes: programmes,
          selected: programmes[0],
          onTap: (programme) => _selected = programme.id,
        ),
        RoundedButton(
          text: Strings.buttonContinue,
          onTap: () {
            Navigator.push(
              context,
              RegisterPageName.routeWith(
                email: widget.email,
                passcode: widget.passcode,
                programmeId: _selected,
              ),
            );
          },
        ),
      ],
    );
  }
}

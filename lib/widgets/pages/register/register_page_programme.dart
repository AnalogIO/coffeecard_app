import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/cubits/programme/programme_cubit.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/utils/fast_slide_transition.dart';
import 'package:coffeecard/widgets/components/error_section.dart';
import 'package:coffeecard/widgets/components/occupation_selection.dart';
import 'package:coffeecard/widgets/components/tickets/rounded_button.dart';
import 'package:coffeecard/widgets/pages/register/register_page_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  var selectedProgrammeId = 0;
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgrammeCubit, ProgrammeState>(
      builder: (context, state) {
        if (state is ProgrammeLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.primary,
            ),
          );
        }

        if (state is ProgrammeError) {
          return ErrorSection(
            error: state.message,
            retry: context.read<ProgrammeCubit>().getProgrammes,
          );
        }

        if (state is! ProgrammeLoaded) {
          throw MatchCaseIncompleteException(this);
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(24)),
                child: OccupationSelection(
                  programmes: state.programmes,
                  selected: state.programmes[selectedIndex].shortName,
                  onTap: (programme) => setState(() {
                    selectedProgrammeId = programme.id;
                    selectedIndex = state.programmes
                        .indexWhere((p) => p.id == programme.id);
                  }),
                ),
              ),
            ),
            RoundedButton(
              text: Strings.buttonContinue,
              onTap: () {
                Navigator.push(
                  context,
                  RegisterPageName.routeWith(
                    email: widget.email,
                    passcode: widget.passcode,
                    programmeId: selectedProgrammeId,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

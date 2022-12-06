import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/cubits/occupation/occupation_cubit.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/utils/fast_slide_transition.dart';
import 'package:coffeecard/widgets/components/error_section.dart';
import 'package:coffeecard/widgets/components/occupation_selection.dart';
import 'package:coffeecard/widgets/components/tickets/rounded_button.dart';
import 'package:coffeecard/widgets/pages/register/register_page_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPageOccupation extends StatefulWidget {
  const RegisterPageOccupation({
    required this.email,
    required this.passcode,
  });

  final String email;
  final String passcode;

  static Route routeWith({required String email, required String passcode}) {
    return FastSlideTransition(
      child: RegisterPageOccupation(email: email, passcode: passcode),
    );
  }

  @override
  State<RegisterPageOccupation> createState() => _RegisterPageOccupationState();
}

class _RegisterPageOccupationState extends State<RegisterPageOccupation> {
  int? selectedOccupationId;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OccupationCubit, OccupationState>(
      builder: (context, state) {
        if (state is OccupationLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.primary,
            ),
          );
        }

        if (state is OccupationError) {
          return ErrorSection(
            error: state.message,
            retry: context.read<OccupationCubit>().getOccupations,
          );
        }

        if (state is! OccupationLoaded) {
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
                  occupations: state.occupations,
                  selected: selectedIndex != null
                      ? state.occupations[selectedIndex!].shortName
                      : null,
                  onTap: (occupation) => setState(() {
                    selectedOccupationId = occupation.id;
                    selectedIndex = state.occupations
                        .indexWhere((p) => p.id == occupation.id);
                  }),
                ),
              ),
            ),
            RoundedButton(
              text: Strings.buttonContinue,
              onTap: selectedOccupationId != null
                  ? () {
                      Navigator.push(
                        context,
                        RegisterPageName.routeWith(
                          email: widget.email,
                          passcode: widget.passcode,
                          occupationId: selectedOccupationId!,
                        ),
                      );
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }
}

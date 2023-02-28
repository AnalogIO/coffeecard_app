import 'package:coffeecard/base/style/colors.dart';
import 'package:coffeecard/errors/match_case_incomplete_exception.dart';
import 'package:coffeecard/features/occupation/domain/entities/occupation.dart';
import 'package:coffeecard/features/occupation/presentation/cubit/occupation_cubit.dart';
import 'package:coffeecard/features/occupation/presentation/widgets/occupation_form.dart';
import 'package:coffeecard/utils/fast_slide_transition.dart';
import 'package:coffeecard/widgets/components/error_section.dart';
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
  Occupation? selectedOccupation;

  void _onSubmit(Occupation occupation) {
    Navigator.of(context).push(
      RegisterPageName.routeWith(
        email: widget.email,
        passcode: widget.passcode,
        occupationId: occupation.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: BlocBuilder<OccupationCubit, OccupationState>(
        builder: (context, state) {
          if (state is OccupationLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.primary),
            );
          }

          if (state is OccupationError) {
            return Center(
              child: ErrorSection(
                error: state.error,
                retry: context.read<OccupationCubit>().fetchOccupations,
              ),
            );
          }

          if (state is! OccupationLoaded) {
            throw MatchCaseIncompleteException(this);
          }

          return OccupationForm(
            selectedOccupation: selectedOccupation,
            occupations: state.occupations,
            onChange: (occupation) => setState(() {
              selectedOccupation = occupation;
            }),
            onContinue: (occupation) => _onSubmit(occupation),
          );
        },
      ),
    );
  }
}

import 'package:coffeecard/core/strings.dart';
import 'package:coffeecard/core/widgets/components/loading.dart';
import 'package:coffeecard/core/widgets/components/scaffold.dart';
import 'package:coffeecard/features/occupation/presentation/cubit/occupation_cubit.dart';
import 'package:coffeecard/features/occupation/presentation/widgets/occupation_form.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeOccupationPage extends StatelessWidget {
  const ChangeOccupationPage();

  static Route get route =>
      MaterialPageRoute(builder: (_) => const ChangeOccupationPage());

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.changeOccupation,
      body: BlocProvider(
        create: (_) => sl<OccupationCubit>()..fetchOccupations(),
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: BlocBuilder<OccupationCubit, OccupationState>(
            builder: (_, occupationState) {
              if (occupationState is! OccupationLoaded) {
                return const SizedBox.shrink();
              }

              return BlocBuilder<UserCubit, UserState>(
                builder: (context, userState) {
                  return Loading(
                    loading: userState is UserUpdating,
                    child: OccupationForm(
                      occupations: occupationState.occupations,
                      selectedOccupation: userState is UserLoaded
                          ? userState.user.occupation
                          : null,
                      onChange: (occupation) => context
                          .read<UserCubit>()
                          .setUserOccupation(occupation.id),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

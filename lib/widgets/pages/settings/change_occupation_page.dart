import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/widgets/components/forms/occupation_form.dart';
import 'package:coffeecard/widgets/components/loading.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
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
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: BlocBuilder<UserCubit, UserState>(
          buildWhen: (_, current) => current is UserLoaded,
          builder: (_, userLoadedState) {
            if (userLoadedState is! UserLoaded) return const SizedBox.shrink();

            return BlocBuilder<UserCubit, UserState>(
              buildWhen: (previous, current) =>
                  previous is UserUpdating || current is UserUpdating,
              builder: (context, state) {
                return Loading(
                  loading: state is UserUpdating,
                  child: OccupationForm(
                    occupations: userLoadedState.occupations,
                    selectedOccupation: userLoadedState.user.occupation,
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
    );
  }
}

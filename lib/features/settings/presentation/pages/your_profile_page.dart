import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/features/settings/presentation/widgets/edit_profile.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:coffeecard/widgets/components/loading.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class YourProfilePage extends StatelessWidget {
  const YourProfilePage();

  static Route get route =>
      MaterialPageRoute(builder: (_) => const YourProfilePage());

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.yourProfilePageTitle,
      body: BlocBuilder<UserCubit, UserState>(
        buildWhen: (_, current) => current is UserLoaded,
        builder: (_, userLoadedState) {
          if (userLoadedState is! UserLoaded) return const SizedBox.shrink();

          return BlocBuilder<UserCubit, UserState>(
            buildWhen: (previous, current) =>
                previous is UserUpdating || current is UserUpdating,
            builder: (context, state) {
              return Loading(
                loading: state is UserUpdating,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 36),
                  child: EditProfile(user: userLoadedState.user),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

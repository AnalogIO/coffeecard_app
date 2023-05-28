import 'package:coffeecard/features/settings/presentation/widgets/user_card.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection();

  @override
  Widget build(BuildContext context) {
    final userState = context.watch<UserCubit>().state;
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: switch (userState) {
        UserLoaded(:final user) => UserCard(
            id: user.id,
            name: user.name,
            occupation: user.occupation.fullName,
          ),
        _ => const UserCard.placeholder(),
      },
    );
  }
}

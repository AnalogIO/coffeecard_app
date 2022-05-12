import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/widgets/components/list_entry.dart';
import 'package:coffeecard/widgets/components/loading.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/settings_list_entry.dart';
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
                child: ListView.builder(
                  itemCount: userLoadedState.programmes.length,
                  itemBuilder: (context, index) {
                    userLoadedState.programmes
                        .sort((a, b) => a.fullName!.compareTo(b.fullName!));
                    final programme = userLoadedState.programmes[index];
                    return SettingListEntry(
                      sideToExpand: ListEntrySide.right,
                      name: '${programme.fullName!} (${programme.shortName!})',
                      valueWidget: Radio(
                        value: programme.shortName!,
                        groupValue: userLoadedState.user.programme.shortName,
                        onChanged: (_) {},
                      ),
                      onTap: () {
                        context
                            .read<UserCubit>()
                            .setUserProgramme(programme.id!);
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/cubits/user/user_cubit.dart';
import 'package:coffeecard/widgets/components/scaffold.dart';
import 'package:coffeecard/widgets/components/settings_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeOccupationPage extends StatelessWidget {
  const ChangeOccupationPage();

  @override
  Widget build(BuildContext context) {
    return AppScaffold.withTitle(
      title: Strings.changeOccupation,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            return ListView.builder(
              itemCount: state.programmes.length,
              itemBuilder: (context, index) {
                state.programmes
                    .sort((a, b) => a.fullName!.compareTo(b.fullName!));
                final programme = state.programmes[index];
                return SettingListEntry(
                  name: '${programme.fullName!} (${programme.shortName!})',
                  valueWidget: Radio(
                    value: programme.shortName!,
                    groupValue: state.user.programme.shortName,
                    onChanged: (_) {},
                  ),
                  onTap: () {
                    context.read<UserCubit>().setUserProgramme(programme.id!);
                    // Navigator.pop(context);
                  },
                );
              },
            );
          }
          //TODO handle programmes not being loaded?
          return const Text('Error');
        },
      ),
    );
  }
}
